package minigames.cardamon 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import minigames.gravnav.KeyboardInput;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	

	public class CardamonMain extends Sprite 
	{
		private var view:CardaminView;
		private var space:CardamonSpace;
		private var input:CardamonInput;
		
		public function CardamonMain() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			space = new CardamonSpace();
			view = new CardaminView();
			view.load(space);
			addChild(view);
			input = new CardamonInput(stage, space);
			
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			space.update(e.timePassed);
			view.update(e.timePassed);
			input.update(e.timePassed);
		}
		
	}

}