package minigames.quad 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	public class QuadMain extends Sprite
	{
		public var model:QuadModel;
		public var view:QuadView;
		
		private var winTime:int;
		private var index:int = 3;
		
		
		public function QuadMain()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			model = new QuadModel();
			view = new QuadView();
			addChild(view);
			load();
			view.x = 250;
			view.y = 250;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		private function onFrame(e:EnterFrameEvent):void
		{
			if (model.isWin)
			{
				winTime += e.timePassed;				
				view.alpha = Math.sin(winTime / (Math.PI * 1000 / 4));
				
				if (winTime > 2000)
				{
					index++;
					removeChild(view);
					view = new QuadView();
					addChild(view);
					view.x = 250;
					view.y = 250;
					model = new QuadModel();
					load();
				}
			}
			
		}
		
		private function onClick(e:MouseEvent):void
		{
			
		}
		
		private function load():void
		{
			model.load(index);
			view.load(model);
			winTime = 0;
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			
		}
		
	}
}