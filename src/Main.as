package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import minigames.tsp.TSPBinder;

	
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{

		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var binder:TSPBinder = new TSPBinder();
			binder.start(this);
			
		}

	}

}