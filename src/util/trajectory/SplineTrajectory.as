package util.trajectory 
{
	import flash.geom.Point;
	

	public class SplineTrajectory extends BaseTrajectory 
	{		
		private var _controlPoints:Vector.<Point>;
		private var _usedPoints:Vector.<Point>;
		public var tension:Number = 1;
		
		override public function moveTo(time:Number):void 
		{
			time = Math.max(time, t1);
			time = Math.min(time, t2);
			var t:Number = (time - t1) / (t2 - t1) * ( _usedPoints.length - 3 ) + 1;
			x = 0;
			y = 0;
			var subT:Number = t - int(t);
			var mainIndex:int = t;
			
			var t1x:Number = (_usedPoints[mainIndex+1].x - _usedPoints[mainIndex-1].x) * tension;
			var t2x:Number = (_usedPoints[mainIndex+2].x - _usedPoints[mainIndex].x) * tension;

			var t1y:Number = (_usedPoints[mainIndex+1].y - _usedPoints[mainIndex-1].y) * tension;
			var t2y:Number = (_usedPoints[mainIndex + 2].y - _usedPoints[mainIndex].y) * tension;
			
			var c1:Number =   2 * Math.pow(subT, 3)  - 3 * Math.pow(subT, 2) + 1;
			var c2:Number = -(2 * Math.pow(subT, 3)) + 3 * Math.pow(subT, 2);
			var c3:Number =       Math.pow(subT, 3)  - 2 * Math.pow(subT, 2) + subT;
			var c4:Number=       Math.pow(subT, 3)  -     Math.pow(subT, 2);
			
			x = c1 * _usedPoints[mainIndex].x + c2 * _usedPoints[mainIndex+1].x + c3 * t1x + c4 * t2x;
			y = c1 * _usedPoints[mainIndex].y + c2 * _usedPoints[mainIndex + 1].y + c3 * t1y + c4 * t2y;
		}
		
		public function get controlPoints():Vector.<Point> 
		{
			return _controlPoints;
		}
		
		public function set controlPoints(value:Vector.<Point>):void 
		{
			_controlPoints = value;
			_usedPoints = _controlPoints.slice();
			_usedPoints.unshift(_controlPoints[0]);
			_usedPoints.push(_controlPoints[_controlPoints.length - 1]);
		}
	}

}