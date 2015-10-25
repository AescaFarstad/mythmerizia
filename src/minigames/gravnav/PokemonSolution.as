package minigames.gravnav 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import util.EnterFramer;
	public class PokemonSolution 
	{
		
		public var turnCount:int;
		public var solution:BallState;
		
		public var breadth:int = 1000;
		public var FRAME_TIME:int = 10;
		
		private var startFrameTime:int;
		private var states:Vector.<BallState>;
		private var statesTraversed:int;
		private var callback:Function;
		private var model:GravnavModel;
		private var DIRECTIONS:Vector.<Point>;
		public var isRunning:Boolean;
		
		public function PokemonSolution() 
		{
			DIRECTIONS = GravnavModel.DIRECTIONS;
		}
		
		public function clear():void
		{
			model = null;
			solution = null;
			turnCount = -2;
			states = null;
			callback = null;
			statesTraversed = 0;
			EnterFramer.removeEnterFrameUpdate(onFrame);
		}
		
		public function find(model:GravnavModel, callback:Function):void
		{
			clear();
			this.model = model;
			this.callback = callback;
			var firstState:BallState = new BallState();
			firstState.history = null;
			firstState.turnCount = 0;
			firstState.balls = new Vector.<Point>();
			for (var i:int = 0; i < model.balls.length; i++) 
			{
				firstState.balls.push(new Point(model.balls[i].x, model.balls[i].y));
			}
			firstState.numBalls = firstState.balls.length;
			states = new Vector.<BallState>();
			states.push(firstState);
			statesTraversed = 0;
			EnterFramer.addEnterFrameUpdate(onFrame);
			isRunning = true;
			onFrame();
		}		
		
		private function onFrame(e:Event = null):void 
		{
			startFrameTime = getTimer();
			while (turnCount < -1)
			{
				iter();
				if (getTimer() - startFrameTime > FRAME_TIME)
					return;
			}
			if (turnCount == -1)
			{
				isRunning = false;
				callback();
			}
			
		}
		
		private function iter():void
		{
			var minBalls:int = int.MAX_VALUE;
			var maxBalls:int = int.MIN_VALUE;
			var numMinBalls:int;
			for (var j:int = 0; j < states.length; j++) 
			{
				if (states[j].numBalls < minBalls)
				{
					numMinBalls = 1;
					minBalls = states[j].numBalls
				}
				else if (states[j].numBalls == minBalls)
				{
					numMinBalls++;
				}
				maxBalls = Math.max(states[j].numBalls, maxBalls);
			}
			if (minBalls == 1)
			{
				for (var n:int = 0; n < states.length; n++) 
				{
					if (states[n].numBalls == 1)
					{
						solution = states[n];
						turnCount = solution.turnCount;
						isRunning = false;
						callback();
						return;
					}
				}
			}
			else
			{
				var statesToExpand:Vector.<BallState>;
				if (minBalls != maxBalls)
				{
					if (numMinBalls < breadth && maxBalls - minBalls == 1)
						statesToExpand = states;
					else
					{							
						statesToExpand = new Vector.<BallState>();
						while (minBalls <= maxBalls && statesToExpand.length < breadth)
						{
							for (var k:int = 0; k < states.length; k++) 
							{
								if (states[k].numBalls == minBalls)
									statesToExpand.push(states[k])
							}
							minBalls++;
						}		
					}				
				}
				else
					statesToExpand = states;
			}
			var newStates:Vector.<BallState> = new Vector.<BallState>();
			for (var l:int = 0; l < statesToExpand.length; l++) 
			{
				for (var m:int = 0; m < DIRECTIONS.length; m++) 
				{
					if (statesToExpand[l].lastMove && (DIRECTIONS[m].x == 0) == (statesToExpand[l].lastMove.x == 0))
						continue;
					newStates.push(statesToExpand[l].applyDirection(DIRECTIONS[m], model));
					statesTraversed++;
					if (statesTraversed > 300000)
					{
						turnCount = -1;
						return;
					}
				}
			}
			states = newStates;
		}
		
	}

}