package engine 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	

	public class KeyboardInput 
	{
		public var pressedKeys:Dictionary;
		public var onKeyDown:Function;
		public var onKeyUp:Function;
		
		public function KeyboardInput(stage:Stage) 
		{
			pressedKeys = new Dictionary();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp);	
			
		}
		
		private function onStageKeyUp(e:KeyboardEvent):void 
		{
			pressedKeys[e.keyCode] = false;
			if (onKeyUp != null)
				onKeyUp(e.keyCode);
		}
		
		private function onStageKeyDown(e:KeyboardEvent):void 
		{
			pressedKeys[e.keyCode] = true;
			if (onKeyDown != null)
				onKeyDown(e.keyCode);
		}
		
	}

}