package minigames.trader 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	public class TraderMain extends Sprite
	{
		
		public var model:TraderModel;
		public var view:TraderView;
		
		public function TraderMain()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			model = new TraderModel();
			model.init();
			view = new TraderView();
			
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