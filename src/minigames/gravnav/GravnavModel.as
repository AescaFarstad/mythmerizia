package minigames.gravnav 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	public class GravnavModel extends EventDispatcher
	{
		
		public static const SIZE_X:int = 50;
		public static const SIZE_Y:int = 40;
		
		public var cells:Vector.<Vector.<Boolean>>;
		public var hero:Hero;
		public var inputCooldown:int;
		public var wasBlocked:Boolean;
		public var finalStates:Vector.<Point>;
		public var turnsTillSolution:int;
		
		public function GravnavModel() 
		{
			restart();
		}
		
		public function restart():void 
		{
			cells = new Vector.<Vector.<Boolean>>();
			for (var i:int = 0; i < SIZE_Y; i++) 
			{
				cells.push(new Vector.<Boolean>());
				for (var j:int = 0; j < SIZE_X; j++) 
				{
					cells[i].push(i != 0 && i != SIZE_Y - 1 && j != 0 && j != SIZE_X -1);
				}
			}
			
			var numObstacles:int = 145;
			for (var l:int = 0; l < numObstacles; l++) 
			{
				var cell:Point = null;
				while (!cell || !cells[cell.y][cell.x])
					cell = new Point(int(Math.random() * SIZE_X), int(Math.random() * SIZE_Y));
				cells[cell.y][cell.x] = false;
				
			}
			
			finalStates = new Vector.<Point>();
			for (var k:int = 0; k < 5; k++) 
			{
				var finalState:Point = new Point(int(Math.random() * SIZE_X), int(Math.random() * SIZE_Y));
				if (cells[finalState.y][finalState.x] == false)
				{
					k--;
					continue;
				}
				finalStates.push(finalState);
			}
			
			hero = new Hero();
			cell = null;
			while (!cell || !cells[cell.y][cell.x])
				cell = new Point(int(Math.random() * SIZE_X), int(Math.random() * SIZE_Y));
			hero.x = cell.x;
			hero.y = cell.y;
			
			if (!checkIsHasSolution())
				restart();
		}
		
		public function checkIsHasSolution():Boolean 
		{
			var maxDepth:int = 25;
			var visitedStaes:Vector.<int> = new Vector.<int>();
			var frontier:Vector.<int> = new Vector.<int>();
			var finals:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < finalStates.length; i++) 
			{
				finals.push(finalStates[i].x * SIZE_X + finalStates[i].y);
			}
			
			frontier.push(hero.x * SIZE_X + hero.y);
			
			var reachedState:Point;
			var result:int = iterate(0);			
			trace("depth", result, "visited", visitedStaes.length);	/*		
			finalStates = new Vector.<Point>();
			finalStates.push(reachedState);*/
			turnsTillSolution = result;
			return result > 10;
			
			function iterate(depth:int):int
			{
				var newFrontier:Vector.<int> = new Vector.<int>();
				for (var j:int = 0; j < frontier.length; j++) 
				{
					var newPoints:Vector.<int> = new <int>[
							expand(frontier[j], -1, 0),
							expand(frontier[j], 1, 0),
							expand(frontier[j], 0, -1),
							expand(frontier[j], 0, 1)
							]
					for (var k:int = 0; k < newPoints.length; k++) 
					{
						if (visitedStaes.indexOf(newPoints[k]) == -1 &&
							frontier.indexOf(newPoints[k]) == -1 &&
							newFrontier.indexOf(newPoints[k]) == -1)
						{
							visitedStaes.push(newPoints[k]);
							newFrontier.push(newPoints[k]);
							if (finals.indexOf(newPoints[k]) != -1)
							{
								reachedState = new Point(int(newPoints[k] / SIZE_X), int(newPoints[k] % SIZE_X));
								return depth;
							}
						}
					}
					
				}
				frontier = newFrontier;
				if (depth < maxDepth)
					return iterate(depth + 1);
				else
					return -1;
			}
			
			function expand(point:int, mx:int, my:int):int
			{
				var x:int = point / SIZE_X;
				var y:int = point % SIZE_X;
				while (cells[y + my][x + mx])
				{
					x += mx;
					y += my;				
				}
				return x * SIZE_X + y;
			}
			
		}
		
		public function update(timePassed:int):void 
		{
			if (inputCooldown > 0)
				wasBlocked = true;
			else
				if (wasBlocked)
			{
				wasBlocked = false;
				checkIsHasSolution();
			}
			if (inputCooldown <= 0 && heroIsInFinalState())
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function heroIsInFinalState():Boolean 
		{
			for (var i:int = 0; i < finalStates.length; i++) 
			{
				if (hero.x == finalStates[i].x && hero.y == finalStates[i].y)
					return true;
			}
			return false;
		}
	}

}