package minigames.gravnav 
{
	import adobe.utils.CustomActions;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import util.GameInfoPanel;
	
	public class GravnavModel extends EventDispatcher
	{
		private static const DIRECTIONS:Vector.<Point> = new <Point>[new Point(0, -1), new Point(1, 0), new Point(0, 1), new Point(-1, 0)];
		
		public static const COOLDOWN:int = 20;
		public static const MAX_COOLDOWN:int = 300;
		public static const SPAWN_PERIOD:int = 3;
		
		public static const SIZE_X:int = 50;
		public static const SIZE_Y:int = 40;
		
		public var cells:Vector.<Vector.<Boolean>>;
		public var hero:Hero;
		public var inputCooldown:int;
		public var wasBlocked:Boolean;
		public var finalStates:Vector.<Point>;
		public var turnsTillSolution:int;
		public var demons:Vector.<GravDemon>;
		public var futurePoints:Vector.<FuturePoint>;
		public var turnCount:int;
		public var lost:Boolean;
		
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
			/*
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
			}*/
			
			hero = new Hero();
			cell = null;
			while (!cell || !cells[cell.y][cell.x])
				cell = new Point(int(Math.random() * SIZE_X), int(Math.random() * SIZE_Y));
			hero.x = cell.x;
			hero.y = cell.y;
			/*
			if (!checkIsHasSolution())
				restart();*/
				
			demons = new Vector.<GravDemon>();
			var numDemons:int = 6;
			for (var m:int = 0; m < numDemons; m++) 
			{
				var demon:GravDemon = new GravDemon();
				while (!cell || !cells[cell.y][cell.x] || cell.x == hero.x && cell.y == hero.y)
					cell = new Point(int(Math.random() * SIZE_X), int(Math.random() * SIZE_Y));
				demon.x = cell.x;
				demon.y = cell.y;
				demons.push(demon);
				cell = null;
				
			}
			
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
							expand(frontier[j], 0, -1),
							expand(frontier[j], 1, 0),
							expand(frontier[j], 0, 1),
							expand(frontier[j], -1, 0)
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
				wasBlocked = false;/*
				checkIsHasSolution();*/
			}
			if (inputCooldown < 0 && lost)
				dispatchEvent(new Event(Event.COMPLETE));
			else if (inputCooldown < 0 && heroIsInFinalState())
			{
				trace(GameInfoPanel.instance.label.text);
				lost = true;
				inputCooldown = 2000;				
			}
		}
		
		public function moveDemons():void 
		{
			//futurePoints = updateFuturePoints(hero.x, hero.y);
			turnCount++;
			if (turnCount % SPAWN_PERIOD == 0)
			{
				var sampleDemon:GravDemon = demons[int(Math.random() * demons.length)];
				var newD:GravDemon = new GravDemon();
				newD.x = sampleDemon.x;
				newD.y = sampleDemon.y;
				demons.push(newD);
				trace("new Demon");
				dispatchEvent(new Event("demon"));
			}
			var length:int;
			for (var i:int = 0; i < demons.length; i++) 
			{
				length = Math.max(length, demons[i].move(this));
			}
			inputCooldown = Math.max(inputCooldown, length * COOLDOWN);
			inputCooldown = Math.min(inputCooldown, MAX_COOLDOWN);
		}
		
		public function updateFuturePoints(x:int, y:int):Vector.<FuturePoint> 
		{
			var result:Vector.<FuturePoint> = new Vector.<FuturePoint>();
			var depth:int = 4;
			var frontier:Vector.<int> = new Vector.<int>();
			frontier.push(x * SIZE_X + y);
			var coveredPoints:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < depth; i++) 
			{
				for (var j:int = 0; j < frontier.length; j++) 
				{
					var futurePoint:FuturePoint = new FuturePoint();
					futurePoint.x = frontier[j] / SIZE_X;
					futurePoint.y = frontier[j] % SIZE_X;
					futurePoint.delay = i;
					result.push(futurePoint);
					coveredPoints.push(frontier[j]);
				}
				var newFrontier:Vector.<int> = new Vector.<int>();
				for (var k:int = 0; k < frontier.length; k++) 
				{
					var extendedPoints:Vector.<Point> = getMoveOptions(frontier[k] / SIZE_X, frontier[k] % SIZE_X);
					for (var l:int = 0; l < extendedPoints.length; l++) 
					{
						var newPoint:int = extendedPoints[l].x * SIZE_X + extendedPoints[l].y;
						if (coveredPoints.indexOf(newPoint) != -1 || newFrontier.indexOf(newPoint) != -1)
							continue;
						newFrontier.push(newPoint);
					}
				}
				frontier = newFrontier;
			}
			result.sort(FuturePoint.sort);
			return result;
		}
		
		public function getFirstStep(fromX:Number, fromY:Number, toX:Number, toY:Number):Point 
		{
			var maxDepth:int = 25;
			var visitedStaes:Vector.<int> = new Vector.<int>();
			var frontier:Vector.<int> = new Vector.<int>();
			var frontierDirections:Vector.<Point> = new Vector.<Point>();
			var finals:Vector.<int> = new Vector.<int>();
			finals.push(toX * SIZE_X + toY);
			
			frontier.push(fromX * SIZE_X + fromY);
			/*
			var reachedState:Point;
			var result:int = iterate(0);			
			trace("depth", result, "visited", visitedStaes.length);	
			turnsTillSolution = result;
			return result > 10;*/
			return iterate(0);
			
			function iterate(depth:int):Point
			{
				var newFrontier:Vector.<int> = new Vector.<int>();
				var newDirections:Vector.<Point> = new Vector.<Point>();
				for (var j:int = 0; j < frontier.length; j++) 
				{
					var newPoints:Vector.<int> = new <int>[
							expand(frontier[j], 0, -1),
							expand(frontier[j], 1, 0),
							expand(frontier[j], 0, 1),
							expand(frontier[j], -1, 0)
							]
					for (var k:int = 0; k < newPoints.length; k++) 
					{
						if (visitedStaes.indexOf(newPoints[k]) == -1 &&
							frontier.indexOf(newPoints[k]) == -1 &&
							newFrontier.indexOf(newPoints[k]) == -1)
						{
							visitedStaes.push(newPoints[k]);
							newFrontier.push(newPoints[k]);
							if (frontierDirections.length > j)
								newDirections.push(frontierDirections[j]);
							else
								newDirections.push(DIRECTIONS[k]);
							if (finals.indexOf(newPoints[k]) != -1)
							{
								return newDirections[newDirections.length - 1];
							}
						}
					}
					
				}
				frontier = newFrontier;
				frontierDirections = newDirections;
				if (depth < maxDepth)
					return iterate(depth + 1);
				else
					return null;
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
		
		public function getMoveOptions(x:Number, y:Number):Vector.<Point>
		{
			var result:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < DIRECTIONS.length; i++)
			{
				var travelX:int = x;
				var travelY:int = y;
				while (cells[travelY + DIRECTIONS[i].y][travelX + DIRECTIONS[i].x])
				{
					travelX += DIRECTIONS[i].x;
					travelY += DIRECTIONS[i].y;				
				}
				if (travelX != x || travelY != y)
					result.push(new Point(travelX, travelY));				
			}
			return result;
		}
		
		
		private function heroIsInFinalState():Boolean 
		{
			for (var i:int = 0; i < demons.length; i++) 
			{
				if (hero.x == demons[i].x && hero.y == demons[i].y)
					return true;
			}
			return false;
		}
	}

}