package util.trajectory 
{
	
	public class ParabolicThrowTrajectory extends BaseTrajectory 
	{
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var gx:Number = 0;
		public var gy:Number = 0;
		
		override public function moveTo(time:Number):void 
		{
			lastTimeInput = time;				
			x = x1 + vx * time + gx * time * time / 2;
			y = y1 + vy * time + gy * time * time / 2;
		}
		
	}

}