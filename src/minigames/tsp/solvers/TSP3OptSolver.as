package minigames.tsp.solvers 
{
	import minigames.tsp.TSPModel;
	import minigames.tsp.Node;
	
	public class TSP3OptSolver implements ITSPSolver 
	{
		
		public function TSP3OptSolver() 
		{
			
		}
		
		public function improve(solution:Vector.<Node>, model:TSPModel):void 
		{
			var originalSolution:Vector.<Node> = solution;
            var currentPoint:int = 0;
            var iterationsDone:int = 0;
            var bruteForceTargets:int = 0;
            var iterationsSuccessful:int = 0;
            var cicles:int = 0;

            var solutionCount:int = solution.length;
            var LIMIT:int = Math.min(20, solutionCount / 2);
            for (var i:int = 0; i < solutionCount; i++)
			{
				var previousPoint:int = currentPoint;
				currentPoint = (currentPoint + 1) % solutionCount;
				var currentPointi:Node = solution[currentPoint];

				var bestPlace:int = -1;
				var bestN:int = -1;
				var reversed:Boolean = false;
				var bestValue:Number = Number.POSITIVE_INFINITY;
				bruteForceTargets++;

				for (var k:int = 0; k < solutionCount; k++)
				{
					var afterK:int = (k + 1) % solutionCount;
					var Ki:Node = solution[k];
					var afterKi:Node = solution[afterK];
					var previousPointi:Node = solution[previousPoint];

					var prevToFirst:Number = previousPointi.distanceTo(currentPointi.x, currentPointi.y);
					var newToFirst:Number = Ki.distanceTo(currentPointi.x, currentPointi.y);
					var newToAfter:Number = Ki.distanceTo(afterKi.x, afterKi.y);
					
					var newToLast:Number = afterKi.distanceTo(currentPointi.x, currentPointi.y);
					
					var totalPrecalculated:Number = -prevToFirst + newToFirst - newToAfter;
					var totalPrecalculated2:Number = -prevToFirst + newToLast - newToAfter;

					var nextPoint:int = currentPoint;
					var nextPointi:Node = currentPointi;

					for (var n:int = 0; n < LIMIT; n++)
					{
						var lastPoint:int = nextPoint;
						var lastPointi:Node = nextPointi;

						nextPoint = (lastPoint + 1) % solutionCount;
						nextPointi = solution[nextPoint];

						var currentToK:int = k > currentPoint ? k - currentPoint : k + solutionCount - currentPoint;
						var lastToAfterK:int = lastPoint > afterK ? lastPoint - afterK : lastPoint + solutionCount - afterK;

						if (currentToK > n && lastToAfterK > n && afterK != currentPoint && k != lastPoint && afterK != lastPoint && k != currentPoint)
						{
							iterationsDone++;

							var lastToNext_prevToNext:Number = -lastPointi.distanceTo(nextPointi.x, nextPointi.y) +
								previousPointi.distanceTo(nextPointi.x, nextPointi.y);

							var lengthChange1:Number = totalPrecalculated + lastToNext_prevToNext + 
								lastPointi.distanceTo(afterKi.x, afterKi.y);

							var lengthChange2:Number = totalPrecalculated2 + lastToNext_prevToNext + 
								lastPointi.distanceTo(Ki.x, Ki.y);

							if (lengthChange1 < 0 && lengthChange1 < bestValue)
							{
								bestPlace = afterK;
								bestN = n;
								bestValue = lengthChange1;
								reversed = false;
							}
							if (lengthChange2 < 0 && lengthChange2 < bestValue)
							{
								bestPlace = afterK;
								bestN = n;
								bestValue = lengthChange2;
								reversed = true;
							}
						}
						else { break; }
					}
				}
				if (bestValue < 0)
				{
					//trace("3opt from", currentPoint, "num", bestN, "destination", bestPlace, "rev", reversed, "cost", model.getLength(solution).toFixed());
					//trace(model.solutionToString(solution));
					iterationsSuccessful++;
/**/
					if (currentPoint + bestN >= solutionCount)
					{
						var rem1:Vector.<Node> = solution.splice(currentPoint, solutionCount - currentPoint);
						rem1 = rem1.concat(solution.splice(0, (currentPoint + bestN) % solutionCount));
						bestPlace -= (currentPoint + bestN) % solutionCount;
						/*
						
						var rem1:Vector.<Node> = solution.slice(currentPoint, solutionCount);
						var secondCount:int = currentPoint + bestN - solution.length + 1;
						rem1.concat(solution.slice(0, secondCount));
						solution.splice(currentPoint, solutionCount - currentPoint);
						solution.splice(0, secondCount);
						bestPlace -= secondCount;*/
						//trace("case hard");
					}
					else
					{
						rem1 = solution.splice(currentPoint, bestN + 1);
						if (currentPoint < bestPlace)
						{
							bestPlace -= bestN + 1;
						}
						//trace("case simple");
					}
					if (reversed)
					{
						rem1.reverse();
					}
					solution=solution.slice(0, bestPlace).concat(rem1).concat(solution.slice(bestPlace));
					//trace(model.solutionToString(solution));
					//trace("cost", model.getLength(solution).toFixed(), "final best place", bestPlace);
				}
			}
			for (var j:int = 0; j < solution.length; j++) 
			{
				originalSolution[j] = solution[j];
			}
		}
		
		
	}

}