package minigames.navgraph 
{
	import flash.geom.Point;
	import util.HMath;
	
	public class Edge
	{
		public var p2:Point;
		public var p1:Point;
		public var length:Number;
		public var center:Point;
		
		public function Edge(p1:Point, p2:Point) 
		{
			this.p1 = p1;
			this.p2 = p2;
			updateLength();
		}
		
		public function updateLength():void
		{
			length = Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
			center = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
		}
		
		public function intersects(edge:Edge):Boolean 
		{
			var range:Number = (length + edge.length) / 2;
			if (range < center.x - edge.center.x || range < center.y - edge.center.y)
				return false;
			return HMath.checkSegmentIntersection(p1, p2, edge.p1, edge.p2) > 0;
		}
		
	}

}