package minigames.tsp.view 
{
	import engine.AnimUpdater;
	import engine.TimeLineManager;
	import flash.display.Sprite;
	
	public class TSPCoreGameView extends Sprite
	{		
		public var timeline:TimeLineManager;
		public var updater:AnimUpdater;
		
		public function TSPCoreGameView() 
		{
			timeline = new TimeLineManager();
			updater = new AnimUpdater();
		}
		
		public function clear():void
		{
			updater.forceComplete();
			timeline.clear();
		}
		
	}

}