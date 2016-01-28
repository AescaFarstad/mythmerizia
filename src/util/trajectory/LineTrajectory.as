package util.trajectory 
{
	
	public class LineTrajectory extends BaseTrajectory 
	{
		
		override public function moveTo(time:Number):void 
		{
			lastTimeInput = time;
			if (t1 == t2)
			{
				if (time == t1)
				{
					x = x1;
					y = y1;
				}/* should throw an error or not?
				else
				{
					throw new Error("invalid data");
				}*/
			}
			else
			{
				x = (time  - t1) * (x1 - x2) / (t1 - t2) + x1;
				y = (time  - t1) * (y1 - y2) / (t1 - t2) + y1;
			}
		}
		
	}

}