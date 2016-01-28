package util.trajectory 
{
	public class BaseTrajectory 
	{
		///first point x
		public var x1:Number;
		///first point y
		public var y1:Number;
		///first point time stamp
		public var t1:Number;
		
		///second point x
		public var x2:Number;
		///second point y
		public var y2:Number;
		///second point time stamp
		public var t2:Number;
		
		///resulting x. Not updated automaticly. Call 'MoveTo' before reading values
		public var x:Number;
		///resulting y. Not updated automaticly. Call 'MoveTo' before reading values
		public var y:Number;		
		
		public var lastTimeInput:Number;	
		
		public var recalculateOnDemand:Boolean;
		
		public function moveTo(time:Number):void
		{
			lastTimeInput = time;
		}
		
		public function recalculateParams():void 
		{
			
		}
		
		public function connectTo(trajectory:BaseTrajectory):void
		{
			x1 = trajectory.x2;
			y1 = trajectory.y2;
			t1 = trajectory.t2;
		}
	}
}