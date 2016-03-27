package util
{
	import flash.geom.Point;
	import minigames.clik_or_crit.model.Country;
	
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
			return Math.abs(directedDistanceFromPointToLine(px, py, l1x, l1y, l2x, l2y));
		}
		
		//is positive if the point is to the left of the line
		static public function directedDistanceFromPointToLine(px:Number, py:Number, l1x:Number, l1y:Number, l2x:Number, l2y:Number):Number 
		{
			if (l1x == l2x)
			{
				if (l1y == l2y)
					throw new Error("Line end points must be different");
				return l1x - px;
			}
			var A:Number = l1y - l2y;
			var B:Number = l2x - l1x;
			var C:Number = l1x * l2y - l2x * l1y;
			return (A * px + B * py + C) / Math.sqrt(A * A + B * B);
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
		
		static public function shuffle(array:*):void
		{
			var length:int = array.length;
			if (length < 2)
				return;
			for (var i:int = 0; i < length - 1; i++)
			{
				var j:int = Math.random() * (length - i) + i;
				var temp:* = array[i];
				array[i] = array[j];
				array[j] = temp;
			}
		}
		
		static public function pointInPolygonRelation(px:Number, py:Number, verticiesList:*):int
		{
			for (var i:int = 0; i < verticiesList.length; i++) 
			{
				var l1:* = verticiesList[i];
				var l2:* = verticiesList[(i + 1) % verticiesList.length];
				var orientation:Number = ((l1.x - px) * (l2.y - py) - (l1.y - py) * (l2.x - px));
				if (orientation >= 0)
					return orientation == 0 ? 0 : -1;
			}
			return 1;
		}
		
		static public function convexHull(ipointsList:*):Array
		{
			if (ipointsList.length < 3)
				return [];
				
			var maxX:* = ipointsList[0];
			var minX:* = ipointsList[0];
			
			for (var i:int = 0; i < ipointsList.length; i++) 
			{
				if (maxX.x < ipointsList[i].x)
					maxX = ipointsList[i];
				if (minX.x > ipointsList[i].x)
					minX = ipointsList[i];
			}
			
			var hull:Array = [maxX, minX];
			var outside:* = ipointsList.slice();
			outside.splice(outside.indexOf(maxX), 1);
			outside.splice(outside.indexOf(minX), 1);
			
			while (outside.length > 0)
			{
				for (var j:int = 0; j < hull.length; j++) 
				{
					if (extendHull())
						j--;
				}
			}
			
			return hull;
			
			function extendHull():Boolean
			{
				var from:int = j;
				var to:int = (j + 1) % hull.length;
				var bestPoint:* = outside[0];
				var bestDistance:Number = Number.NEGATIVE_INFINITY;
				for (var k:int = 0; k < outside.length; k++) 
				{
					var distance:Number = directedDistanceFromPointToLine(outside[k].x, outside[k].y, hull[from].x, hull[from].y, hull[to].x, hull[to].y);
					if (distance > bestDistance)
					{
						bestDistance = distance;
						bestPoint = outside[k];
					}
				}
				
				if (bestDistance > 0)
				{
					var newOutside:Array = [];
					var polygon:Array = [hull[from], bestPoint, hull[to]];
					for (k = 0; k < outside.length; k++) 
					{
						if (pointInPolygonRelation(outside[k].x, outside[k].y, polygon) < 0)
						{
							newOutside.push(outside[k]);
						}
					}
					outside = newOutside;
					hull.splice(to, 0, bestPoint);
				}
				return bestDistance > 0;
			}			
		}
		
		static public function distance(ipoint1:*, ipoint2:*):Number 
		{
			return Math.sqrt((ipoint2.x - ipoint1.x) * (ipoint2.x - ipoint1.x) + (ipoint2.y - ipoint1.y) * (ipoint2.y - ipoint1.y));
		}
		/**/
	}

}