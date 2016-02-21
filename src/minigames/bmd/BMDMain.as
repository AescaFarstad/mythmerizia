package minigames.bmd 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	public class BMDMain extends Sprite
	{
		private var model:BMDModel;
		private var view:*;
		
		public function BMDMain()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			model = new BMDModel();
			model.init();/*
			view = new BMDView();
			addChild(view);
			view.load(model);*/
			
			BMDStarling.onNewInstance.addEventListener(Event.ADDED, onViewAdded);
			_starling = new Starling(BMDStarling, stage);
			_starling.start();
			starling.enableErrorChecking = true;
			
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		private function onViewAdded(e:Event):void
		{
			view = BMDStarling.instance;
			view.load(model);
		}
		
		private function onFrame(e:EnterFrameEvent):void
		{
			model.update(e.timePassed);
			if (view)
				view.update(e.timePassed);
		}
		
	}
}