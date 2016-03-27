package minigames.clik_or_crit 
{
	import engine.EngineTimeManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import minigames.clik_or_crit.lib.CCDataSource;
	import minigames.clik_or_crit.lib.CCLibrary;
	import minigames.clik_or_crit.model.CCModel;
	import minigames.clik_or_crit.view.CCView;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	import util.HMath;
	
	public class CCMain extends Sprite 
	{
		private var model:CCModel;
		private var view:CCView;
		
		private var timeManager:EngineTimeManager = new EngineTimeManager();
		
		public function CCMain() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			/**/
			CCLibrary.init();
			
			model = new CCModel();
			model.init();
			CCDataSource.init(model);			
			
			view = new CCView();
			addChild(view);
			view.load(model);
			
			EnterFramer.addEnterFrameUpdate(onFrame);
			
			timeManager.load(this);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			view.clear();
			view.load(model);
		}
		
		public function update(timePassed:int):void
		{
			timePassed *= 4;
			model.update(timePassed);
			view.update(timePassed);			
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			timeManager.onFrame(null);
		}
		
	}
	

}