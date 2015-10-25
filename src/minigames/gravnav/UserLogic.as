package minigames.gravnav 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import util.DebugRug;
	import util.EnterFramer;
	import util.GameInfoPanel;
	
	public class UserLogic 
	{
		private static const KEYS:Vector.<uint> = new <uint>[Keyboard.UP, Keyboard.RIGHT, Keyboard.DOWN, Keyboard.LEFT];
		private static const DIRECTIONS:Vector.<Point> = new <Point>[new Point(0, -1), new Point(1, 0), new Point(0, 1), new Point(-1, 0)];
		
		private var model:GravnavModel;
		private var keyboard:KeyboardInput;
		private var lastKeyDown:uint;
		
		
		public function UserLogic() 
		{
			
		}
		
		public function init(stage:Stage):void 
		{
			keyboard = new KeyboardInput(stage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (model.inputCooldown <= 0)
			{
				tryToMove(e.keyCode);
			}
			else
			{
				lastKeyDown = e.keyCode;
			}
		}
		
		private function tryToMove(keyCode:uint):void
		{
			var index:int = KEYS.indexOf(keyCode);
			if (index != -1)
			{
				for (var j:int = 0; j < model.balls.length; j++) 
				{
					var length:int = Math.max(length, model.balls[j].travel(DIRECTIONS[index], model));
				}
				model.inputCooldown = GravnavModel.COOLDOWN * length;
				if (length > 0)
				{									
					model.turnCount++;
					model.updateSolution();
				}
			}
		}
		
		public function load(model:GravnavModel):void 
		{
			this.model = model;	
			var startTimer:int;
			//var pokemon:PokemonSolution = new PokemonSolution();
			//pokemon.FRAME_TIME = 1000000;
			
			var nums:Array = [5, 10, 15, 20, 25, 30, 50, 65, 80, 100, 120, 150, 200, 250, 300, 400, 500, 750, 1000, 1500, 2000];
				var scores:Vector.<int> = new Vector.<int>();
				var times:Vector.<int> = new Vector.<int>();
				var fails:Vector.<int> = new Vector.<int>();
				for (var l:int = 0; l < nums.length; l++) 
				{
					scores.push(0);
					times.push(0);
					fails.push(0);
				}
				/*
				EnterFramer.addEnterFrameUpdate(onFrame);
				var iters:int = 200;
				var itersLeft:int = iters;
				var currentNumTest:int = 0;
				model.restart();
				
				function onFrame():void 
				{
					if (pokemon.isRunning)
						return;
					iter();
					if (itersLeft == 0)
					{						
						EnterFramer.removeEnterFrameUpdate(onFrame);
						for (var m:int = 0; m < nums.length; m++) 
						{
							trace(nums[m].toString() + ":\ttime:", times[m], "\tscore:", scores[m], "\tfails:", fails[m]);
						}
					}
				}
				
				function iter():void
				{
					if (currentNumTest == 0)
						trace("iter", iters - itersLeft);
					if (currentNumTest >= nums.length)
					{
						model.restart();
						currentNumTest = 0;
						itersLeft--;
						return;
					}
					
					startTimer = getTimer();
					pokemon.breadth = nums[currentNumTest];
					pokemon.find(model, onDone);
					
				}
				
				function onDone():void
				{
					var solution:BallState = pokemon.solution;
					var k:int = currentNumTest;
					if (solution)
					{
						times[k] += getTimer() - startTimer;
						scores[k] += solution.turnCount;						
					}
					else
					{
						fails[k]++;
						trace("fail at ", k, pokemon.breadth);
					}
					currentNumTest++;
				}*/
				
		}
		
		public function update(timePassed:int):void 
		{
			var length:int = 0;
			model.inputCooldown -= timePassed;
			if (model.inputCooldown <= 0 && lastKeyDown > 0)
			{
				tryToMove(lastKeyDown);
				lastKeyDown = 0;
			}
			return;
			if (model.inputCooldown <= 0)
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
							//if (model.cells[model.hero.y + DIRECTIONS[i].y][model.hero.x + DIRECTIONS[i].x])
							{
								//trace("GIP:", GameInfoPanel.instance.label.text);
								for (var j:int = 0; j < model.balls.length; j++) 
								{
									length = Math.max(length, model.balls[j].travel(DIRECTIONS[i], model));
								}
								model.inputCooldown = GravnavModel.COOLDOWN * length;
								if (length > 0)
								{									
									model.turnCount++;
									model.updateSolution();
								}
								return;
							}
						}
					}
				}
			}
			if (keyboard.activeKeys[Keyboard.SPACE])
			{/*
				DebugRug.whyNotVisible(GameInfoPanel.instance.label);
				var lastState:BallState = model.getBallsSolution();
				while (lastState.history)
				{
					if (lastState.lastMove.x == -1)
						trace("left", lastState.numBalls);
					if (lastState.lastMove.y == -1)
						trace("up", lastState.numBalls);
					if (lastState.lastMove.x == 1)
						trace("right", lastState.numBalls);
					if (lastState.lastMove.y == 1)
						trace("down", lastState.numBalls);
					lastState = lastState.history;
				}*/
				//model.test(100, [5, 10, 15, 20, 25, 30, ]
				
				
			}
		}
		
		
		public function get isInputEnabled():Boolean
		{
			return model.inputCooldown <= 0;
		}
		
	}

}