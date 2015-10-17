package util
{
	import flash.geom.Point;
	
	public class HMath 
	{		
		/// (x1, y1) and (x2, y2) - base points, input - the point of interest (x3). Returns y3
		static public function linearInterp(x1:Number, y1:Number, x2:Number, y2:Number, input:Number):Number 
		{
			if (x1 == x2)
				return y1 == y2 ? y1 : NaN;
			return (input  - x1) * (y1 - y2) / (x1 - x2) + y1;
		}
		
		/// (x1, y1) and (x2, y2) - base points, input - the point of interest (x3). Returns y3
		static public function nonlinearInterp(x1:Number, y1:Number, x2:Number, y2:Number, power:Number, input:Number):Number 
		{
			if (x1 == x2)
				return y1 == y2 ? y1 : NaN;
			x1 = Math.pow(x1, power);
			x2 = Math.pow(x2, power);
			input = Math.pow(input, power);
			return (input  - x1) * (y1 - y2) / (x1 - x2) + y1;
		}
		
		///Simulates moving with acceleration
		///(x1, y1) and (x2, y2) - base points, input - the point of interest (x3). Returns y3
		static public function accelInterp(x1:Number, y1:Number, x2:Number, y2:Number, accel:Number, input:Number):Number 
		{
			if (x1 == x2)
				return y1 == y2 ? y1 : NaN;
			var vel0:Number = ((y2 - y1) + accel * (x1 * x1 - x2 * x2) / 2) / (x2 - x1);
			var y0:Number = y1 - x1 * vel0 - accel * x1 * x1 / 2;
			return y0 + input * vel0 + accel * input * input / 2;
		}
		
		///returns angle between 0 and 2PI.
		static public function normilizeAngle(angle:Number):Number 
		{
			angle = angle % (Math.PI * 2);
			angle = angle < 0 ? Math.PI * 2 + angle : angle;
			return angle;
		}
		
		///returns positive delta if it's shorter to go counter clockwise.
		static public function angleShortestDelta(from:Number, to:Number):Number 
		{
			from = normilizeAngle(from);
			to = normilizeAngle(to);
			if (from < to)
				return to - from < Math.PI ? to - from : to - from - Math.PI * 2;
			else
				return from - to < Math.PI ? to - from : to - from + Math.PI * 2;
			
		}
		
		static public function distanceFromPointToLine(px:Number, py:Number, l1x:Number, l1y:Number, l2x:Number, l2y:Number):Number 
		{
			if (l1x == l2x)
			{
				if (l1y == l2y)
					throw new Error("Line end points must be different");
				return Math.abs(l1x - px);
			}
			var A:Number = l1y - l2y;
			var B:Number = l2x - l1x;
			var C:Number = l1x * l2y - l2x * l1y;
			return Math.abs(A * px + B * py + C) / Math.sqrt(A * A + B * B);
		}
		
		static public function distanceFromPointToSegment(px:Number, py:Number, s1x:Number, s1y:Number, s2x:Number, s2y:Number):Number 
		{
			var v1x:Number = s2x - s1x;
			var v1y:Number = s2y - s1y;
			
			var v2x:Number = px - s1x;
			var v2y:Number = py - s1y;
			
			var angle1:Number = v1x * v2x + v1y * v2y;
			if (angle1 < 0)
				return Math.sqrt(v2x * v2x + v2y * v2y);
			var angle2:Number = v1x * v1x + v1y * v1y;
			if (angle2 < angle1)
				return Math.sqrt((px - s2x) * (px - s2x) + (py - s2y) * (py - s2y));
			return distanceFromPointToLine(px, py, s1x, s1y, s2x, s2y);
		}
		
		static public function pointOnPerpendicularBisector(x1:Number, y1:Number, x2:Number, y2:Number, distance:Number, direction:int):Point
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			
			var angle:Number =  Math.atan2(dy, dx);
			var px:Number = (x2 + x1) / 2 + Math.cos(angle + Math.PI / 2 * direction) * distance; 
			var py:Number = (y2 + y1) / 2 + Math.sin(angle + Math.PI / 2 * direction) * distance;
			
			return new Point(px, py);
		}
		
		static public function rotateVector(x:Number, y:Number, angle:Number):Point
		{
			return new Point(x * Math.cos(angle) - y * Math.sin(angle), x * Math.sin(angle) + y * Math.cos(angle));
		}
		
		static public function normalizeVector(x:Number, y:Number):Point 
		{
			var length:Number = Math.sqrt(x * x + y * y);
			return new Point(x / length, y / length);
		}
		
		///returns -1 if don't intersect, 0 if touch, 1 if intersect
		///Assumes segments are non-zero length and not overlapping
		static public function checkSegmentIntersection(s11:Point, s12:Point, s21:Point, s22:Point):int 
		{
			if (s11.equals(s21) || s11.equals(s22) || s12.equals(s21) || s12.equals(s22))
				return 0;
				
			if (Math.min(s11.x, s12.x) > Math.max(s21.x, s22.x) || 
				Math.min(s11.y, s12.y) > Math.max(s21.y, s22.y) ||
				Math.min(s21.x, s22.x) > Math.max(s11.x, s12.x) ||
				Math.min(s21.y, s22.y) > Math.max(s11.y, s12.y)
				)
				return -1;
				
			var intersectionPoint:Point = linesIntersection(s11, s12, s21, s22);
			if (!intersectionPoint)
				return -1;
			var antiError:Number = 0.0000001;
			var belogs:Boolean = Math.min(s11.x, s12.x) - intersectionPoint.x < antiError &&  Math.max(s11.x,s12.x) - intersectionPoint.x > -antiError &&
								Math.min(s11.y, s12.y) - intersectionPoint.y < antiError &&  Math.max(s11.y,s12.y) - intersectionPoint.y > -antiError &&
								Math.min(s21.x, s22.x) - intersectionPoint.x < antiError &&  Math.max(s21.x,s22.x) - intersectionPoint.x > -antiError &&
								Math.min(s21.y, s22.y) - intersectionPoint.y < antiError &&  Math.max(s21.y,s22.y) - intersectionPoint.y > -antiError;
			return belogs ? 1 : -1;
		}
		
		static public function linesIntersection(s11:Point, s12:Point, s21:Point, s22:Point):Point
		{
			var A1:Number = s12.y - s11.y;
			var B1:Number = s11.x - s12.x;
			var C1:Number = A1 * s11.x + B1 * s11.y;
			
			var A2:Number = s22.y - s21.y;
			var B2:Number = s21.x - s22.x;
			var C2:Number = A2 * s21.x + B2 * s21.y;
			
			var det:Number = A1 * B2 - A2 * B1;
			if (det == 0)
				return null;
			var intersectionX:Number = (B2 * C1 - B1 * C2) / det;
			var intersectionY:Number = (A1 * C2 - A2 * C1) / det;
			return new Point(intersectionX, intersectionY);
		}
		
	}

}