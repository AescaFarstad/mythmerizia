package minigames.knitting 
{
	import flash.geom.Point;
	import util.HMath;
	public class KnitModel
	{
		private static const numSeeds:int = 4;
		private static const minRelDistance:Number = 0.1;
		
		private var sizeX:Number;
		private var sizeY:Number;
		private var numInputs:int;
		private var numPoints:int;
		
		public var points:Vector.<Point>;
		public var paths:Vector.<Vector.<Point>>;
		
		public var inputPoints:Vector.<Point>;
		public var outputPoints:Vector.<Point>;
		private var freePoints:Vector.<Point>;
		private var unusedPoints:Vector.<Point>;
		
		public function KnitModel()
		{
			
		}
		
		public function load(sizeX:Number, sizeY:Number, numInputs:int, numPoints:int):void
		{
			this.numPoints = numPoints;
			this.numInputs = numInputs;
			this.sizeY = sizeY;
			this.sizeX = sizeX;
			
			initInputs();
			initFreePoints();
			initPaths();
		}
		
		public function splinePaths():void
		{
			var offenders:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < paths.length; i++)
			{
				var bestPoint:Point;
				var bestAngle:Number = Math.PI * 2;
				for (var j:int = 1; j < paths[i].length - 1; j++)
				{
					var angle:Number = HMath.angleShortestDelta(
							Math.atan2(paths[i][j + 1].y - paths[i][j].y, paths[i][j + 1].x - paths[i][j].x),
							Math.atan2(paths[i][j - 1].y - paths[i][j].y, paths[i][j - 1].x - paths[i][j].x));
					if (angle < bestAngle)
					{
						bestAngle = angle;
						bestPoint = paths[i][j];
					}
				}
				offenders.push(bestPoint);
				trace("offender ", paths[i].indexOf(bestPoint), "/", paths[i].length - 1);
				paths[i].splice(paths[i].indexOf(bestPoint), 1);
			}
			HMath.shuffle(offenders);
			
			for (i = 0; i < paths.length; i++)
			{
				var bestIndex:int;
				var bestAngle:Number = 0;
				for (var j:int = 1; j < paths[i].length; j++)
				{
					var angle:Number = HMath.angleShortestDelta(
							Math.atan2(paths[i][j].y - offenders[i].y, paths[i][j].x - offenders[i].x),
							Math.atan2(paths[i][j - 1].y - offenders[i].y, paths[i][j - 1].x - offenders[i].x));
					if (angle > bestAngle)
					{
						bestAngle = angle;
						bestIndex = j;
					}
				}
				paths[i].splice(bestIndex, 0, offenders[i]);
				trace("offender in:", paths[i].indexOf(offenders[i]), "/", paths[i].length - 1);
			}
		}
		
		private function initPaths():void
		{
			paths = new Vector.<Vector.<Point>>();
			unusedPoints = freePoints.slice();
			for (var i:int = 0; i < numInputs; i++)
			{
				var path:Vector.<Point> = new Vector.<Point>();
				paths.push(path);
				path.push(inputPoints[i]);
				var numPathPoints:int = unusedPoints.length / (numInputs - i);
				for (var j:int = 0; j < numPathPoints; j++)
				{
					var index:int = Math.random() * unusedPoints.length;
					var p:Point = unusedPoints[index];
					unusedPoints.splice(index, 1);
					path.push(p);
				}				
				path.push(outputPoints[i]);
			}
		}
		
		private function initFreePoints():void
		{
			var p:Point;
			freePoints = new Vector.<Point>();
			var minDistance:Number = minRelDistance * Math.sqrt(sizeX * sizeY) * Math.SQRT2 / (numPoints + numInputs * 2);
			for (var j:int = 0; j < numPoints; j++)
			{
				var bestPoint:Point = null;
				var bestDistance:Number = 0;
				for (var k:int = 0; k < numSeeds; k++)
				{
					p = null;
					var pool:Array = [];
					var nearestPoint:Point;
					var distance:Number;
					while (!p || distance < minDistance)
					{						
						p = new Point(Math.random() * sizeX, Math.random() * sizeY);
						nearestPoint = getNearestPoint(p);
						distance = nearestPoint.subtract(p).length;
					}
					if (distance > bestDistance)
					{
						bestDistance = distance;
						bestPoint = p;
					}
				}
				freePoints.push(bestPoint);
				points.push(bestPoint);
			}
		}
		
		private function initInputs():void
		{			
			points = new Vector.<Point>();
			inputPoints = new Vector.<Point>();
			outputPoints = new Vector.<Point>();
			for (var i:int = 0; i < numInputs; i++)
			{
				var p:Point = new Point(sizeX / numInputs * (i + 0.5), 0);
				inputPoints.push(p);
				points.push(p);
				
				p = new Point(sizeY / numInputs * (i + 0.5), sizeY);
				outputPoints.push(p);
				points.push(p);
			}
			HMath.shuffle(outputPoints);
		}
		
		private function getNearestPoint(p:Point):Point
		{
			var bestPoint:Point;
			var bestDistance:Number = Number.POSITIVE_INFINITY;
			for (var i:int = 0; i < points.length; i++)
			{
				var distance:Number = points[i].subtract(p).length;
				if (distance < bestDistance)
				{
					bestDistance = distance;
					bestPoint = points[i];
				}
			}
			return bestPoint;
		}
		
	}
}