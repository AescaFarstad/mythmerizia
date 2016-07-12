package minigames.roads 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	public class Roads extends Sprite
	{
		public var model:RoadsModel;
		public var view:RoadsView;
		
		public function Roads()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			model = new RoadsModel();
			model.init();
			view = new RoadsView();
			
			view.x = 50;
			view.y = 50;
			addChild(view);
			view.load(model);
			
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		private function onFrame(e:EnterFrameEvent):void
		{
			model.update(e.timePassed);
			view.update(e.timePassed);
		}
		
	}
}