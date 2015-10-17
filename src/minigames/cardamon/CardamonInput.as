package minigames.cardamon 
{
	import engine.KeyboardInput;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	

	public class CardamonInput 
	{
		private var keyInput:KeyboardInput;
		private var space:CardamonSpace;
		
		public function CardamonInput(stage:Stage, space:CardamonSpace) 
		{
			this.space = space;
			
			keyInput = new KeyboardInput(stage);
		}
		
		public function update(timePassed:int):void 
		{
			var hor:int = keyInput.pressedKeys[Keyboard.RIGHT] ? 1 : 0;
			hor += keyInput.pressedKeys[Keyboard.LEFT] ? -1 : 0;
			
			var ver:int = keyInput.pressedKeys[Keyboard.DOWN] ? -1 : 0;
			ver += keyInput.pressedKeys[Keyboard.UP] ? 1 : 0;
			
			if (hor || ver)
			{
				//space.hero.move(new Point(hor, ver), timePassed, space);
				space.hero.accel(new Point(ver, hor), timePassed, space);
			}
		}
		
	}

}