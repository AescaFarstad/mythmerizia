package util.trajectory 
{
	import com.playflock.util.MathUtil;
	
	public class CircleTrajectory extends BaseTrajectory 
	{
		///0 - half of a circle, 0.86 - thrid of a circle etc...
		public var radiusRatio:Number; 
		///1 - to the right, -1 = to the left (or the other way around??)
		public var prefferedNormal:int = 1;
		
		private var _radius:Number;
		private var _centerX:Number;
		private var _centerY:Number;
		private var _fromAngle:Number;
		private var _toAngle:Number;		
		
		override public function moveTo(time:Number):void 
		{
			lastTimeInput = time;
			if (!recalculateOnDemand)
				recalculateParams();
			var angle:Number = MathUtil.linearInterp(t1, _fromAngle, t2, _toAngle, time);
			x = _centerX + Math.cos(angle) * _radius;
			y = _centerY + Math.sin(angle) * _radius;
		}
		
		override public function recalculateParams():void 
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			
			var angle:Number =  Math.atan2(dy, dx);
			var normalDistance:Number = Math.sqrt(dx * dx + dy * dy) * radiusRatio;
			_centerX = (x2 + x1) / 2 + Math.cos(angle + Math.PI / 2 * prefferedNormal) * normalDistance; 
			_centerY = (y2 + y1) / 2 + Math.sin(angle + Math.PI / 2 * prefferedNormal) * normalDistance;
			
			_fromAngle = Math.atan2(y1 - _centerY, x1 - _centerX);
			_toAngle = _fromAngle + 
				MathUtil.angleShortestDelta(_fromAngle, Math.atan2(y2 - _centerY, x2 - _centerX));
			_radius = Math.sqrt((_centerX - x1)* (_centerX - x1) + (_centerY - y1) * (_centerY - y1));
		}
		
	}

}