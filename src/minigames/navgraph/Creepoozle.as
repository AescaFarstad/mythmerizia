package minigames.navgraph 
{
	import flash.geom.Point;
	
	public class Creepoozle 
	{
		private const speed:Number = 0.02;
		
		public var targets:Vector.<Point>;
		public var color:uint;
		public var x:Number;
		public var y:Number;
		public var nextIndex:int = 1;
		public var path:Array;
		private var pathFinder:PathFinder;
		private var isDone:Boolean;
		public var nextPathIndex:int;
		public var pathLengths:Vector.<Number> = new Vector.<Number>();
		public var nodeCounts:Vector.<int> = new Vector.<int>();
		public var badPaths:int = 0;
		
		public function Creepoozle(targets:Vector.<Point>, pathFinder:PathFinder) 
		{
			this.pathFinder = pathFinder;
			this.targets = targets;
			color = 0xffffff * Math.random();
			x = targets[0].x;
			y = targets[0].y;
			path = pathFinder.getPath(targets[nextIndex - 1], targets[nextIndex]);
			if (!path)
				isDone = !advancePath();
		}
		
		public function update(timePassed:int):void 
		{
			if (isDone)	
				return;
			if (!tryFollowPath(timePassed))
			{
				isDone = !advancePath();
			}
		}
		
		public function refreshPath():void 
		{
			if (!isDone)
				advancePath();
		}
		
		private function advancePath():Boolean
		{
			badPaths--;
			do
			{
				badPaths++;
				nextIndex++;
				if (nextIndex == targets.length)
				{
					isDone = true;
					return false;
				}		
				path = pathFinder.getPath(new Point(x, y), targets[nextIndex]);
			}		
			while (!path)
			pathLengths.push(NavSpace.getPathLength(path));
			nodeCounts.push(path.length);
			nextPathIndex = 1;
			NavDemo.pathCount++;
			return true;
		}
		
		private function tryFollowPath(timePassed:int):Boolean 
		{
			if (x == path[nextPathIndex].x && y == path[nextPathIndex].y)
			{
				nextPathIndex++;
				NavDemo.nodeCount++;	
				if (nextPathIndex == path.length)
					return false;
			}
			var step:Number = timePassed * speed;
			if ((path[nextPathIndex].x - x) * (path[nextPathIndex].x - x) + (path[nextPathIndex].y - y) * (path[nextPathIndex].y - y) <= step * step)
			{
				x = path[nextPathIndex].x;
				y = path[nextPathIndex].y;
			}
			else
			{
				var angle:Number = Math.atan2(path[nextPathIndex].y - y, path[nextPathIndex].x - x);
				x += Math.cos(angle) * step;
				y += Math.sin(angle) * step;
			}
			
			return true;
		}
		
	}

}