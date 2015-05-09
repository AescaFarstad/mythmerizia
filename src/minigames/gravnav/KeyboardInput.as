package minigames.gravnav 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	public class KeyboardInput 
	{
		public var activeKeys:Dictionary = new Dictionary();
		
		public function KeyboardInput(stage:Stage) 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			activeKeys[e.keyCode] = false;
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			activeKeys[e.keyCode] = true;
		}
		
	}

}