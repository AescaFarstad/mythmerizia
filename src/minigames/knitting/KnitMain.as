package minigames.knitting 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class KnitMain extends Sprite
	{
		private var model:KnitModel;
		private var view:KnitView;
		
		public function KnitMain()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			model = new KnitModel();
			model.load(600, 400, 4, 20);
			view = new KnitView();
			addChild(view);
			view.load(model);
			view.x = 200;
			view.y = 200;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			model.splinePaths();
			view.load(model);
		}
		
	}
}