package minigames.tsp 
{
	import flash.geom.Point;
	import util.HMath;
	
	public class Edge implements IInteractable
	{
		public var p1:Node;
		public var p2:Node;
		public var index:int;
		public var center:Point;
		public var length:Number;
		
		
		public function Edge(p1:Node, p2:Node) 
		{
			if (p1 == p2)
				throw new Error("Invalide edge, points are equal.");
			this.p1 = p1;
			this.p2 = p2;
			length = p1.distanceTo(p2.x, p2.y);
			center = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
		}
		
		public function distanceToPoint(x:Number, y:Number):Number
		{
			return distanceFromPointToSegment(x, y, p1.x, p1.y, p2.x, p2.y);
		}
		
		public function toString():String
		{
			return p1.x.toFixed() +p1.y.toFixed() + p2.x.toFixed() + p2.y.toFixed();
		}
		
		public function theOtherPoint(p:Node):Node
		{
			return p == p1 ? p2 : p1;
		}
		
		public function intersects(edge:Edge):Boolean 
		{
			var range:Number = (length + edge.length) / 2;
			if (range < center.x - edge.center.x || range < center.y - edge.center.y)
				return false;
			return HMath.checkSegmentIntersection(p1.point, p2.point, edge.p1.point, edge.p2.point) > 0;
		}
		
		static private function distanceFromPointToLine(px:Number, py:Number, l1x:Number, l1y:Number, l2x:Number, l2y:Number):Number 
		{
			if (l1x == l2x)
			{
				if (l1y == l2y)
					throw new Error("Line end points must be different");
				return Math.abs(l1x - px);
			}
			var A:Number = l1y - l2y;
			var B:Number = l2x - l1x;
			var C:Number = l1x * l2y - l2x * l1y;
			return Math.abs(A * px + B * py + C) / Math.sqrt(A * A + B * B);
		}
		
		static private function distanceFromPointToSegment(px:Number, py:Number, s1x:Number, s1y:Number, s2x:Number, s2y:Number):Number 
		{
			var v1x:Number = s2x - s1x;
			var v1y:Number = s2y - s1y;
			
			var v2x:Number = px - s1x;
			var v2y:Number = py - s1y;
			
			var angle1:Number = v1x * v2x + v1y * v2y;
			if (angle1 < 0)
				return Math.sqrt(v2x * v2x + v2y * v2y);
			var angle2:Number = v1x * v1x + v1y * v1y;
			if (angle2 < angle1)
				return Math.sqrt((px - s2x) * (px - s2x) + (py - s2y) * (py - s2y));
			return distanceFromPointToLine(px, py, s1x, s1y, s2x, s2y);
		}
		
	}

}