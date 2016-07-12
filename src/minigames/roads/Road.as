package minigames.roads 
{
	import flash.geom.Point;
	
	public class Road
	{
		public var p1:Point;
		public var p2:Point;
		public var capacity:int = 1;
		public var free:int;
		public var numCars:int;
		public var maxVelocity:Number = 1 / 2 / 1000;
		
		public function Road(p1:Point, p2:Point)
		{
			this.p2 = p2;
			this.p1 = p1;
			
		}
		
	}
}