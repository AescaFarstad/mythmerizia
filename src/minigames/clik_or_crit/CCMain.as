package minigames.clik_or_crit 
{
	import flash.display.Sprite;
	import flash.events.Event;
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
		}
		
		
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			model.update(e.timePassed);
			view.update(e.timePassed);
		}
		
	}
	

}