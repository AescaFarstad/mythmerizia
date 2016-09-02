package minigames.roads 
{
	import flash.geom.Point;
	
	public class Road
	{
		public var p1:Point;
		public var p2:Point;
		public var center:Point;
		public var capacity:int = 1;
		public var free:int;
		public var numCars:int;
		public var maxVelocity:Number = 1 / 2 / 1000;
		public var numCapacityInc:int;
		public var numSpeedInc:int;
		public var tmpCapacityIncrease:Number = 0;
		
		public function Road(p1:Point, p2:Point)
		{
			this.p2 = p2;
			this.p1 = p1;
			center = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
		}
		
		public function getSpeed():Number
		{
			return maxVelocity * (1 - numCars / (getResultingCapacity() + 1));
		}
		
		public function update(timePassed:int):void
		{
			tmpCapacityIncrease -= timePassed / 1000 / 30;
			tmpCapacityIncrease *= Math.pow(0.998, timePassed);
			tmpCapacityIncrease = Math.max(0, tmpCapacityIncrease);
		}
		
		public function getResultingCapacity():Number
		{
			return capacity + tmpCapacityIncrease;
		}
		
	}
}