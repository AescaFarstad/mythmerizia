package minigames.roads 
{
	import flash.geom.Point;
	
	public class Station
	{
		public var p1:Point;
		public var p2:Point;
		public var carsPerMs:Number = 0;
		public var stage:int;
		public var index:int
		
		public function Station(p1:Point, p2:Point, stage:int, index:int)
		{
			this.index = index;
			this.stage = stage;
			this.p1 = p1;			
			this.p2 = p2;			
		}
		
	}
}