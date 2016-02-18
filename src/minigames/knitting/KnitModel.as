package minigames.knitting 
{
	import flash.geom.Point;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	import util.HMath;
	import util.RMath;
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
		public var initialPaths:Vector.<Vector.<Point>>;
		public var targetPaths:Vector.<Vector.<Point>>;
		
		public var inputPoints:Vector.<Point>;
		public var outputPoints:Vector.<Point>;
		private var freePoints:Vector.<Point>;
		private var unusedPoints:Vector.<Point>;
		
		public var solutionProgress:Number = 0;
		
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
			
			solutionProgress = 0;
			copyPoints();
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
				bestAngle = 0;
				for (j = 1; j < paths[i].length; j++)
				{
					angle = HMath.angleShortestDelta(
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
		
		public function solve():void
		{
			EnterFramer.addEnterFrameUpdate(onFrame);
			copyPoints();
		}
		
		private function copyPoints():void
		{
			initialPaths = paths.slice();
			targetPaths = new Vector.<Vector.<Point>>();
			for (var i:int = 0; i < initialPaths.length; i++)
			{
				initialPaths[i] = initialPaths[i].slice();
				targetPaths.push(new Vector.<Point>());
				for (var j:int = 0; j < initialPaths[i].length; j++)
				{
					initialPaths[i][j] = initialPaths[i][j].clone();
					targetPaths[i][j] = getTarget(i, j);
				}
			}
		}
		
		private function onFrame(e:EnterFrameEvent):void
		{
			var totalTime:int = 2000;
			solutionProgress = Math.min(solutionProgress + e.timePassed / totalTime, 1);
			
			movePointsToProgress();			
			
			if (solutionProgress == 1)
				EnterFramer.removeEnterFrameUpdate(onFrame);
		}
		
		public function movePointsToProgress():void
		{
			for (var i:int = 0; i < paths.length; i++)
			{
				for (var j:int = 1; j < paths[i].length - 1; j++)
				{
					paths[i][j].x = HMath.linearInterp(0, initialPaths[i][j].x, 1, targetPaths[i][j].x, solutionProgress);
					paths[i][j].y = HMath.linearInterp(0, initialPaths[i][j].y, 1, targetPaths[i][j].y, solutionProgress);
				}
			}
		}
		
		private function getTarget(i:int, j:int):Point
		{
			return new Point(
					HMath.linearInterp(0, paths[i][0].x, paths[i].length - 1, paths[i][paths[i].length - 1].x, j),
					HMath.linearInterp(0, paths[i][0].y, paths[i].length - 1, paths[i][paths[i].length - 1].y, j));
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
				
				var weights:Vector.<Number> = new Vector.<Number>();
				for (var k:int = 0; k < unusedPoints.length; k++)
				{
					weights.push(Math.pow(HMath.distanceFromPointToLine(
							unusedPoints[i].x, unusedPoints[i].y, 
							inputPoints[i].x, inputPoints[i].y, 
							outputPoints[i].x, outputPoints[i].y), 3)); 
				}
				
				var pickedPoints:Array = RMath.weightedRandom(unusedPoints, weights, numPathPoints, true, true, 5);
				RMath.shuffleList(pickedPoints);
				
				for (var j:int = 0; j < pickedPoints.length; j++)
				{
					var index:int = unusedPoints.indexOf(pickedPoints[j]);
					unusedPoints.splice(index, 1);
					path.push(pickedPoints[j]);
				}				
				path.push(outputPoints[i]);
			}
			/*
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
			}*/
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
			HMath.shuffle(inputPoints);
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