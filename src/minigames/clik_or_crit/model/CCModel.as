package minigames.clik_or_crit.model 
{
	import minigames.clik_or_crit.lib.CCLibrary;
	import minigames.clik_or_crit.lib.CountryItem;
	import minigames.rabbitHole.Resource;
	import org.osflash.signals.Signal;
	import util.HMath;
	import util.RMath;
	import util.binds.Bind;
	import util.binds.BindManager;
	import util.binds.ParamConnection;
	import util.binds.Parameter;
	
	public class CCModel 
	{
		public var onCountryTaken:Signal = new Signal(Country);
		public var onCountryDiscovered:Signal = new Signal(Country);
		public var countries:Vector.<Country>;
		public var hull:Vector.<Country>;
		public var resources:Vector.<Resource>;
		public var bindManager:BindManager;
		public var money:Resource;
		
		public var scoutInPrice:Parameter = new Parameter("scoutInPrice");
		public var scoutOutPrice:Parameter = new Parameter("scoutOutPrice");
		public var scoutsDone:Bind = new Bind("scoutsDone");
		
		public function CCModel() 
		{
			
		}
		
		public function init():void 
		{
			countries = new Vector.<Country>();	
			resources = new Vector.<Resource>();
			bindManager = new BindManager();
			
			
			scoutInPrice.modify(0, 2, 0, "initMulti");
			scoutOutPrice.modify(0, 3, 0, "initMulti");
			
			scoutInPrice.modify(0, 1, 5, "initValue");
			scoutOutPrice.modify(0, 1, 25, "initValue");
			
			scoutsDone.connect(scoutInPrice, ParamConnection.TYPE_ADD1);
			scoutsDone.connect(scoutOutPrice, ParamConnection.TYPE_ADD1);
			
			bindManager.registerBind(scoutsDone);
			
			
		}
		
		public function loadCountry(countryItem:CountryItem):void 
		{
			var item:Country = new Country();
			item.load(countryItem);
			countries.push(item);
		}
		
		public function takeCountry(country:Country):void 
		{
			if (country.discovered && !country.owned)
			{
				country.owned = true;
				reloadHull();
				onCountryTaken.dispatch(country);
			}
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < resources.length; i++) 
			{
				resources[i].update(timePassed);
			}
		}
		
		public function scoutIn():void 
		{
			if (!hull)
				return;
				
			var viableCountries:Vector.<Country> = new Vector.<Country>();
			for (var i:int = 0; i < countries.length; i++) 
			{
				var polyRelation:int = HMath.pointInPolygonRelation(countries[i].x, countries[i].y, hull);
				if (!countries[i].discovered && polyRelation != -1)
					viableCountries.push(countries[i]);
			}
			if (viableCountries.length == 0)
				return;
				
			var country:Country = RMath.getItem(viableCountries);
			country.discovered = true;			
			onCountryDiscovered.dispatch(country);
			
			money.value -= scoutInPrice.value;
			scoutsDone.value++;
		}
		
		public function scoutOut():void 
		{
			var viableCountries:Vector.<Country> = new Vector.<Country>();
			for (var i:int = 0; i < countries.length; i++) 
			{
				var discovered:Boolean = countries[i].discovered;
				var outsideBorder:Boolean = !hull || HMath.pointInPolygonRelation(countries[i].x, countries[i].y, hull) == -1;
				if (!discovered && outsideBorder)
					viableCountries.push(countries[i]);
			}
			if (viableCountries.length == 0)
				return;
				
			var country:Country = RMath.getItem(viableCountries);
			country.discovered = true;
			onCountryDiscovered.dispatch(country);
			
			money.value -= scoutOutPrice.value;
			scoutsDone.value++;
		}
		
		public function loadResource(object:Object):void 
		{
			var resource:Resource = new Resource(object.name);
			bindManager.registerBind(resource);
			resource.load(object);
			resources.push(resource);
			if (resource.name == "money")
				money = resource;
		}
		
		private function reloadHull():void 
		{
			var claimedCountries:Vector.<Country> = new Vector.<Country>();
			for (var i:int = 0; i < countries.length; i++) 
			{
				if (countries[i].owned)
					claimedCountries.push(countries[i]);
			}
			
			if (claimedCountries.length < 3)
			{
				hull = null;
				return;
			}
			
			hull = Vector.<Country>(HMath.convexHull(claimedCountries));
		}
		
	}

}