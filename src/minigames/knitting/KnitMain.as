package minigames.knitting 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
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
			view = new KnitView();
			addChild(view);
			load()
			view.x = 100;
			view.y = 100;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			load();
		}
		
		private function load():void
		{
			model.load(800, 600, 4, 36);
			view.load(model);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
				model.solve();
			else
			{
				model.splinePaths();
				view.load(model);				
			}
		}
		
	}
}