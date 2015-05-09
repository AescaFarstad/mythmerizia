package minigames.gravnav 
{
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class UserLogic 
	{
		private static const COOLDOWN:int = 50;
		private static const KEYS:Vector.<uint> = new <uint>[Keyboard.UP, Keyboard.RIGHT, Keyboard.DOWN, Keyboard.LEFT];
		private static const DIRECTIONS:Vector.<Point> = new <Point>[new Point(0, -1), new Point(1, 0), new Point(0, 1), new Point(-1, 0)];
		
		private var model:GravnavModel;
		private var keyboard:KeyboardInput;
		
		private var inputCooldown:int;
		
		public function UserLogic() 
		{
			
		}
		
		public function init(stage:Stage):void 
		{
			keyboard = new KeyboardInput(stage);			
		}
		
		public function load(model:GravnavModel):void 
		{
			this.model = model;			
		}
		
		public function update(timePassed:int):void 
		{
			inputCooldown -= timePassed;
			if (inputCooldown <= 0)
			{
				var keyPressed:Boolean = false;
				for (var i:int = 0; i < KEYS.length; i++) 
				{
					if (keyboard.activeKeys[KEYS[i]])
					{
						if (keyPressed)
							return;
						else
							keyPressed = true;
					}
				}
				if (keyPressed)
				{
					for (i = 0; i < KEYS.length; i++) 
					{
						if (keyboard.activeKeys[KEYS[i]])
						{
							if (model.cells[model.hero.y + DIRECTIONS[i].y][model.hero.x + DIRECTIONS[i].x])
							{
								var length:int = model.hero.travel(DIRECTIONS[i], model);
								inputCooldown = COOLDOWN * length;
								return;
							}
						}
					}
				}
			}
		}
		
		public function get isInputEnabled():Boolean
		{
			return inputCooldown <= 0;
		}
		
	}

}