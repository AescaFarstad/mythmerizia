package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import minigames.gravnav.Gravnav;
	import minigames.tsp.solvers.TSPSessionManager;
	import resources.Resources;
	import util.EnterFramer;
	import util.ITimeProvider;
	import util.SimpleLogger;

	
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite implements ITimeProvider
	{
		private static var _instance:Main;

		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			_instance = this;
		}
		
		
		public function get currentTime():int 
		{
			return getTimer();
		}
		
		static public function get instance():Main 
		{
			return _instance;
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			S.resources = new Resources();
			S.resources.loadResources();
			S.text = S.resources.text;			
			S.format = S.resources.text.format;			
			S.pics = S.resources.pics;	
			
			SimpleLogger.instance.init(this);
			addChild(new EnterFramer());
			
			/*
			
			var binder:TSPBinder = new TSPBinder();
			binder.start(this);*/
			/*
			var tsp:TSPSessionManager = new TSPSessionManager();
			tsp.init(this);*/
			addChild(new Gravnav());
		}

	}

}