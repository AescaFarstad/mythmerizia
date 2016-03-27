package minigames.clik_or_crit.model 
{
	import engine.Updater;
	import flash.geom.Point;
	import minigames.clik_or_crit.lib.BuildingItem;
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
		
		public var resources:Vector.<Resource>;
		public var bindManager:BindManager;
		public var money:Resource;
		
		public var updater:Updater = new Updater();
		
		private var that:CCModel;
		
		public var scouting:Scouting;
		public var input:CCInput;
		
		public function CCModel() 
		{
			that = this;
			scouting = new Scouting(this);
			input = new CCInput(this);
		}
		
		public function init():void 
		{
			resources = new Vector.<Resource>();
			bindManager = new BindManager();
			
			scouting.init();
		}
		
		public function loadCountry(countryItem:CountryItem):void 
		{
			var item:Country = new Country();
			item.load(countryItem);
			scouting.countries.push(item);
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < resources.length; i++) 
			{
				resources[i].update(timePassed);
			}
			
			updater.update(timePassed);
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
		
	}

}