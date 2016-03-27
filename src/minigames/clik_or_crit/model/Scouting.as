package minigames.clik_or_crit.model 
{
	import flash.geom.Point;
	import minigames.clik_or_crit.lib.BuildingItem;
	import org.osflash.signals.Signal;
	import util.HMath;
	import util.RMath;
	import util.binds.Bind;
	import util.binds.ParamConnection;
	import util.binds.Parameter;
	public class Scouting 
	{
		public var model:CCModel;
		
		public var onBuildingConstructed:Signal = new Signal(BuildingItem, Country);
		public var onCountryTaken:Signal = new Signal(Country);
		public var onCountryDiscovered:Signal = new Signal(Country);
		public var countries:Vector.<Country>;
		public var hull:Vector.<Country>;
		
		public var scoutInPrice:Parameter = new Parameter("scoutInPrice");
		public var scoutOutPrice:Parameter = new Parameter("scoutOutPrice");
		public var scoutInTime:Parameter = new Parameter("scoutInTime");
		public var scoutOutTime:Parameter = new Parameter("scoutOutTime");
		public var buildingTime:Parameter = new Parameter("buildingTime");
		public var priceMulti:Parameter = new Parameter("priceMulti", 1);
		public var timeMulti:Parameter = new Parameter("timeMulti", 1);
		
		
		public var scoutsDone:Bind = new Bind("scoutsDone");
		public var buildingsDone:Bind = new Bind("buildingsDone");
		
		
		public var scoutProcess:Process = new Process("scoutProcess");
		public var buildingProcess:BuildingProcess = new BuildingProcess("buildingProcess");
		
		
		public function Scouting(model:CCModel) 
		{
			this.model = model;
			
		}
		
		public function init():void
		{			
			countries = new Vector.<Country>();	
			
			scoutInPrice.modify(0, 2, 0, "initMulti");
			scoutOutPrice.modify(0, 3, 0, "initMulti");
			
			scoutInPrice.modify(0, 1, 5, "initValue");
			scoutOutPrice.modify(0, 1, 25, "initValue");
			
			scoutInTime.modify(0, 500, 0, "initMulti");
			scoutOutTime.modify(0, 500, 0, "initMulti");
			buildingTime.modify(0, 500, 0, "initMulti");
			
			scoutInTime.modify(0, 1, 1000, "initValue");
			scoutOutTime.modify(0, 1, 2000, "initValue");
			buildingTime.modify(0, 1, 1000, "initValue");
			
			scoutsDone.connect(scoutInPrice, ParamConnection.TYPE_ADD1);
			scoutsDone.connect(scoutOutPrice, ParamConnection.TYPE_ADD1);
			
			scoutsDone.connect(scoutInTime, ParamConnection.TYPE_ADD1);
			scoutsDone.connect(scoutOutTime, ParamConnection.TYPE_ADD1);
			scoutsDone.connect(buildingTime, ParamConnection.TYPE_ADD1);
			
			buildingsDone.connect(scoutInTime, ParamConnection.TYPE_ADD1);
			buildingsDone.connect(scoutOutTime, ParamConnection.TYPE_ADD1);
			buildingsDone.connect(buildingTime, ParamConnection.TYPE_ADD1);
			
			priceMulti.connect(scoutInPrice, ParamConnection.TYPE_MULTI);
			priceMulti.connect(scoutOutPrice, ParamConnection.TYPE_MULTI);			
			timeMulti.connect(scoutInTime, ParamConnection.TYPE_MULTI);
			timeMulti.connect(scoutOutTime, ParamConnection.TYPE_MULTI);
			timeMulti.connect(buildingTime, ParamConnection.TYPE_MULTI);
			
			model.bindManager.registerBind(scoutsDone);
			model.bindManager.registerBind(buildingsDone);
			
			model.updater.push(scoutProcess);		
			model.updater.push(buildingProcess);		
		}
		
		public function scoutIn():void 
		{
			if (!hull)
				return;
				
			if (!scoutProcess.isComplete)
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
				
			model.money.value -= scoutInPrice.value;
			
			var country:Country = RMath.getItem(viableCountries);
			scoutProcess.load(scoutInTime.value);
			scoutProcess.onCompleted.addOnce(onComplete);
			
			function onComplete():void
			{
				scoutsDone.value++;
				country.discovered = true;			
				onCountryDiscovered.dispatch(country);				
			}
		}
		
		public function scoutOut():void 
		{				
			if (!scoutProcess.isComplete)
				return;
				
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
				
			model.money.value -= scoutOutPrice.value;
			
			var country:Country = RMath.getItem(viableCountries);
			
			scoutProcess.load(scoutOutTime.value);
			scoutProcess.onCompleted.addOnce(onComplete);
			
			function onComplete():void
			{
				scoutsDone.value++;
				country.discovered = true;			
				onCountryDiscovered.dispatch(country);				
			}
		}
		
		public function tryToBuild(building:BuildingItem, country:Country):void 
		{
			if (!buildingProcess.isComplete)
				return;
			
			if (!canBuild(building, country))
				return;
				
			buildingProcess.building = building;
			buildingProcess.load(building.time * timeMulti.value + buildingTime.value);
			buildingProcess.onCompleted.addOnce(onComplete);			
			
			function onComplete():void
			{
				buildingsDone.value++;
				country.building = building;
				building.action.exec(model, building.actionParams, "building at country " + country.lib.id);
				onBuildingConstructed.dispatch(building, country);		
			}			
		}
		
		public function canBuild(buildingItem:BuildingItem, country:Country):Boolean 
		{
			for (var i:int = 0; i < countries.length; i++) 
			{
				if (countries[i].building == buildingItem)
				{
					var distance:Number = distance(countries[i], country);
					if (distance < buildingItem.radius / 100)
						return false;
				}
			}
			return true;
		}
		
		public function reloadHull():void 
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
		
		public function distance(ipoint1:*, ipoint2:*):Number
		{
			var wrappedDistance:Number;
			if (ipoint1.x < ipoint2.x)
				wrappedDistance = HMath.distance(new Point(ipoint1.x + 1, ipoint1.y), ipoint2);
			else
				wrappedDistance = HMath.distance(new Point(ipoint2.x + 1, ipoint2.y), ipoint1);
				
			return Math.min(HMath.distance(ipoint1, ipoint2), wrappedDistance);
		}
		
	}

}