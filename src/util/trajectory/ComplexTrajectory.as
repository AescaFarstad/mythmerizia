package util.trajectory 
{
	import com.playflock.util.tools.vtweener.easing.BaseVEasing;
	
	public class ComplexTrajectory extends BaseTrajectory 
	{
		public var trajectories:Vector.<BaseTrajectory>;
		public var coefficients:Vector.<Number>;
		public var timeEasing:BaseVEasing;
		public var timeEasingParam:Number = 1;
		
		override public function moveTo(time:Number):void 
		{
			if (!recalculateOnDemand)
				recalculateParams();
			x = 0;
			y = 0;
			if (timeEasing)
				time = timeEasing.ease(time, t1, t2 - t1, timeEasingParam);
			for (var i:int = 0; i < trajectories.length; i++) 
			{
				trajectories[i].moveTo(time);
				x += trajectories[i].x * coefficients[i];
				y += trajectories[i].y * coefficients[i];
			}
		}
		
		override public function recalculateParams():void 
		{
			if (!trajectories || !coefficients || trajectories.length != coefficients.length)
				throw new Error("Invalid input data");
			
			for (var i:int = 0; i < trajectories.length; i++) 
			{
				trajectories[i].t1 = t1;
				trajectories[i].t2 = t2;
				trajectories[i].x1 = x1;
				trajectories[i].y1 = y1;
				trajectories[i].x2 = x2;
				trajectories[i].y2 = y2;
				
				trajectories[i].recalculateParams();
			}
		}
		
		
	}

}