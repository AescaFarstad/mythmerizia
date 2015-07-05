package minigames.navgraph 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class QuadNode 
	{
		private var children:Vector.<QuadNode>;
		private var fromX:Number;
		private var fromY:Number;
		private var toX:Number;
		private var toY:Number;
		
		private var halfX:Number;
		private var halfY:Number;
		
		private var items:Array;
		private var maxDepth:int;
		private var depth:int;
		
		public function QuadNode(depth:int, maxDepth:int, fromX:Number, fromY:Number, toX:Number, toY:Number) 
		{
			this.depth = depth;
			this.maxDepth = maxDepth;
			this.toY = toY;
			this.toX = toX;
			this.fromY = fromY;
			this.fromX = fromX;
			
			halfX = (toX + fromX) / 2;
			halfY = (toY + fromY) / 2;
			
			items = [];
			
			if (depth < maxDepth)
			{
				children = new Vector.<QuadNode>();
				
				var child:QuadNode = new QuadNode(depth + 1, maxDepth, fromX, fromY, halfX, halfY);
				children.push(child);
				child = new QuadNode(depth + 1, maxDepth, halfX, fromY, toX, halfY);
				children.push(child);
				child = new QuadNode(depth + 1, maxDepth, halfX, halfY, toX, toY);
				children.push(child);
				child = new QuadNode(depth + 1, maxDepth, fromX, halfY, halfX, toY);
				children.push(child);
			}
		}
		
		public function push(item:*):void
		{
			if (children)
			{
				for (var i:int = 0; i < children.length; i++) 
				{
					if (children[i].belongs(item.p1, item.p2))
					{					
						children[i].push(item);
						return;
					}
				}				
			}
			items.push(item);
		}
		
		public function remove(item:*):void
		{
			
		}
		
		public function query(from:Point, to:Point):Array
		{
			var result:Array = items.slice();
			if (children)
			{
				for (var i:int = 0; i < children.length; i++) 
				{
					if (children[i].overlaps(from, to))
					{					
						result = result.concat(children[i].query(from, to));
					}
				}				
			}
			return result;
			/*
			if (!children || (from.x - halfX) * (to.x - halfX) <= 0 || (from.y - halfY) * (to.y - halfY) <= 0)
				result = items.slice();
			else
			{
				for (var i:int = 0; i < children.length; i++) 
				{
					if (children[i].belongs(from, to)
					{					
						return children[i]
					}
				}	
			}*/
		}
		
		public function overlaps(p1:Point, p2:Point):Boolean 
		{
			return (p1.x < toX && p2.x > fromX &&
					p1.y < toY && p2.y > fromY);
		}
		
		public function belongs(p1:Point, p2:Point):Boolean
		{
			return 	p1.x > fromX && 
					p1.y > fromY &&/*
					p1.x < toX &&
					p1.y < toY &&
					p2.x > fromX && 
					p2.y > fromY &&*/
					p2.x < toX &&
					p2.y < toY;
		}
		
		public function getDebug():Array
		{
			var result:Array = [{depth:depth, count:items.length}];
			if (children)
			{
				for (var i:int = 0; i < children.length; i++) 
				{
					result = result.concat(children[i].getDebug());
				}
			}
			return result;
		}
		
		public function traceStats():void
		{
			var stats:Array = getDebug();
			var counts:Vector.<int> = new Vector.<int>();
			for (var j:int = 0; j <= maxDepth; j++) 
			{
				counts.push(0);
			}
			for (var i:int = 0; i < stats.length; i++) 
			{
				counts[stats[i].depth] += stats[i].count;
			}
			
			for (j = 0; j <= maxDepth; j++) 
			{
				trace("Level", j, counts[j]);
			}
		}
		
	}

}