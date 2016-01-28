package util.trajectory 
{
	import flash.geom.Point;
	
	public class BSplineTrajectory extends BaseTrajectory 
	{
		public var controlPoints:Vector.<Point>;
		public var order:int;
		
		private var _knots:Vector.<Number>;
		
		override public function moveTo(time:Number):void 
		{
			var t:Number = (time - t1) / (t2 - t1) * ( controlPoints.length - order + 1 ) + order - 1;
			x = 0;
			y = 0;
			
			_knots = new Vector.<Number>();
			for (var j:int = 0; j < order + controlPoints.length; j++) 
			{
				_knots.push(j);
			}
			
			var from:int = Math.max(1, t - order + 2);
			var to:int = Math.min(controlPoints.length, t+1);
			
			for(var i:int = from; i <= to; i++)
            {
                var weight:Number = calculateWeightForPointI(i, order, t);
                x += weight * controlPoints[i - 1].x;
                y += weight * controlPoints[i - 1].y;
            }
		}
		
		private function calculateWeightForPointI(i:int, order:int, t:Number):Number 
		{
			if(order == 1)
				return (t >= _knots[i - 1] && t < _knots[i]) ? 1 : 0;
			
			var result:Number = 0;
			
			var a:Number = (_knots[i + order-2] - _knots[i-1]);
			var b:Number = (_knots[i-1 + order] - _knots[i]);
			if(a != 0)
				result += (t - _knots[i-1]) / a * calculateWeightForPointI(i, order-1, t);
			if(b != 0)
				result += (_knots[i-1 + order] - t) / b * calculateWeightForPointI(i+1, order-1, t);

			return result;
		}
		
	}

}