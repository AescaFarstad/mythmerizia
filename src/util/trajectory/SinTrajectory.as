package util.trajectory 
{
	import com.playflock.util.MathUtil;
	
	public class SinTrajectory extends LineTrajectory 
	{
		public var halfPeriodNum:int;
		public var amplitude:Number;
		
		private var _directionAngle:Number;
		private var _fromAngle:Number;
		private var _toAngle:Number;
		
		
		override public function moveTo(time:Number):void 
		{
			lastTimeInput = time;
			if (!recalculateOnDemand)
				recalculateParams();
			super.moveTo(time);
			
			var angle:Number = MathUtil.linearInterp(t1, _fromAngle, t2, _toAngle, time);
			var div:Number = Math.sin(angle) * amplitude;
			x += Math.cos(_directionAngle + Math.PI / 2) * div;
			y += Math.sin(_directionAngle + Math.PI / 2) * div;
		}
		
		override public function recalculateParams():void 
		{
			_fromAngle = 0;
			_toAngle = Math.PI * halfPeriodNum;
			_directionAngle = Math.atan2(y2 - y1, x2 - x1);
		}
		
	}

}