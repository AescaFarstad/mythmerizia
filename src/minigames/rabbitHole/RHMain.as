package minigames.rabbitHole 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import minigames.rabbitHole.view.RHView;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	public class RHMain extends Sprite
	{
		private var engine:Engine;
		private var view:RHView;
	
	public class RHMain extends Sprite
	{
		
		public function RHMain()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			engine = new Engine();
			DataSource.initEngine(engine);
			view = new RHView();
			addChild(view);
			view.load(engine);
			
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			engine.update(e.timePassed);
			view.update(e.timePassed);
		}
		
	}
}