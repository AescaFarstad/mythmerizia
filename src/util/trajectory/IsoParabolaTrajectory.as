package util.trajectory 
{
	import com.playflock.util.MathUtil;
	
	public class IsoParabolaTrajectory extends BaseTrajectory 
	{
		///z at the peak of the parabola
		public var maxZ:Number;
		private var _parabola:Object;
			
		override public function moveTo(time:Number):void 
		{
			lastTimeInput = time;
			if (!recalculateOnDemand)
				recalculateParams();
			super.moveTo(time);
			
			var z:Number = _parabola.a * time * time + _parabola.b * time +_parabola.c;
				
			x = MathUtil.linearInterp(t1, x1, t2, x2, time);
			y = MathUtil.linearInterp(t1, y1, t2, y2, time) - z;
		}
		
		override public function recalculateParams():void 
		{
			_parabola = MathUtil.parabolaBy2RootsAndTop(t1, t2, maxZ);
		}
		
	}

}