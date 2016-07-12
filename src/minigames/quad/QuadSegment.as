package minigames.quad 
{
	import flash.geom.Point;
	public class QuadSegment
	{
		public var p1:Point;
		public var p2:Point;
		public var owner:SingleQuadView;
		
		public function QuadSegment(p1:Point, p2:Point, owner:SingleQuadView)
		{
			this.owner = owner;
			this.p2 = p2;
			this.p1 = p1;
			
		}
		
		public function get center():Point
		{
			return new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
		}
		
	}
}