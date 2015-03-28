package minigames.tsp 
{
	import flash.geom.Point;
	
	public class TSPModel 
	{
		private var scaleX:Number;
		private var scaleY:Number;
		public var nodes:Vector.<Node>
		
		
		public function TSPModel() 
		{
			
		}
		
		public function initWithTest(num:int, width:Number, height:Number):void
		{
			this.scaleY = height;
			this.scaleX = width;
			nodes = new Vector.<Node>();
			var center:Node = new Node(width / 2, height / 2);
			center.index = 0;
			var radius:Number = Math.min(width, height) / 3;
			nodes.push(center);
			num--;
			for (var i:int = 0; i < num; i++) 
			{
				var node:Node = new Node(center.x + radius * Math.cos(Math.PI * 2 / num * i), center.y + radius * Math.sin(Math.PI * 2 / num * i));
				node.index = i + 1;
				nodes.push(node);
			}
		}
		
		public function init(num:int, poissonFactor:int, width:Number, height:Number):void
		{
			this.scaleY = height;
			this.scaleX = width;
			poissonFactor++;
			nodes = new Vector.<Node>();
			for (var i:int = 0; i < num; i++) 
			{
				var bestPoint:Node = null;
				var bestDistance:Number = -1;
				for (var j:int = 0; j < poissonFactor; j++) 
				{
					var p:Node = new Node(Math.random() * width, Math.random() * height);
					var distance:Number = leastQDistanceTo(p);
					if (distance > bestDistance)
					{
						bestDistance = distance;
						bestPoint = p;
					}					
				}
				bestPoint.index = nodes.length;
				nodes.push(bestPoint);
			}
		}
		
		private function leastQDistanceTo(p:Node):Number 
		{
			var leastDistance:Number = Number.POSITIVE_INFINITY;
			for (var i:int = 0; i < nodes.length; i++) 
			{
				leastDistance = Math.min(leastDistance, (nodes[i].x - p.x) * (nodes[i].x - p.x) + (nodes[i].y - p.y) * (nodes[i].y - p.y));
			}
			return leastDistance;
		}
		
		public function getNearestPoint(x:Number, y:Number):Node
		{
			var bestNode:Node;
			var bestDistance:Number = Number.POSITIVE_INFINITY;
			for (var i:int = 0; i < nodes.length; i++) 
			{
				var distance:Number = (nodes[i].x - x) * (nodes[i].x - x) + (nodes[i].y - y) * (nodes[i].y - y);
				if (distance < bestDistance)
				{
					bestDistance = distance;
					bestNode = nodes[i];
				}
			}
			return bestNode;
		}
			
		public function getLength(solution:Vector.<Node>):Number 
		{
			var result:Number = 0;
			for (var i:int = 1; i < solution.length; i++) 
			{
				result += solution[i - 1].distanceTo(solution[i].x, solution[i].y);
			}
			result += solution[solution.length - 1].distanceTo(solution[0].x, solution[0].y);
			return result;
		}
		
		public function solutionToString(solution:Vector.<Node>):String 
		{
			var arr:Array = [];
			for (var i:int = 0; i < solution.length; i++) 
			{
				arr.push(solution[i].index);
			}
			return arr.join(", ");
		}
	}

}