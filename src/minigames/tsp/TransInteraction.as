package minigames.tsp 
{
	import flash.events.Event;
	
	public class TransInteraction extends BaseInteraction 
	{
		public static const UPDATE_PERIOD:int = 300;
		
		private var callback:Function;
		private var lastUpdateStamp:int;
		private var time:int;
		private var isComplete:Boolean;
		private var targetSolution:TSPSolution;
		public var differences:Vector.<SolutionDifference> = new Vector.<SolutionDifference>();
		public var nextStepAllowed:Boolean = true;
		
		public function TransInteraction(model:TSPModel, solution:TSPSolution, targetSolution:TSPSolution, callback:Function) 
		{
			super(model);
			this.targetSolution = targetSolution;
			this.callback = callback;
			this.solution = solution;			
			edges = solution.toEdges();
			
			
			/*
			trace("target")
			trace(targetSolution.toString());*/
			if (solution.vec[0] != targetSolution.vec[0])
			{
				var index:int = targetSolution.vec.indexOf(solution.vec[0]);
				var modified:Vector.<Node> = targetSolution.vec.slice(index).concat(targetSolution.vec.slice(0, index));
				for (var i:int = 0; i < modified.length; i++) 
				{
					targetSolution.vec[i] = modified[i];
				}
			}
			if (solution.vec[1] == targetSolution.vec[targetSolution.vec.length - 1])
			{
				var newVec:Vector.<Node> = targetSolution.vec.reverse().slice(0, targetSolution.vec.length - 1);
				newVec.unshift(targetSolution.vec[targetSolution.vec.length - 1]);
				targetSolution.fromVec(newVec);
			}
			
			
			/*
			trace("target rotated")
			trace(targetSolution.toString());
			trace("current")
			trace(solution.toString());*/
		}
		
		override public function updateInteractable(x:Number, y:Number, timePassed:int):void 
		{
			time += timePassed;
			while (!isComplete)
			{
				update();
			}
			callback();
			/*
			if (lastUpdateStamp < time - UPDATE_PERIOD && nextStepAllowed)
			{
				if (isComplete)
					callback();
				else
				{
					update();
					lastUpdateStamp = time;
					//nextStepAllowed = false;
				}
			}*/
		}
		
		private function update():void 
		{
			var secondSolution:TSPSolution = new TSPSolution(model);
			var lastDifference:SolutionDifference = differences.length > 0 ? differences[differences.length - 1] : null;
			secondSolution.fromSolution(lastDifference ? lastDifference.solution2 : solution);
			step3Opt(secondSolution.vec, targetSolution.vec);
			var difference:SolutionDifference = new SolutionDifference(lastDifference ? lastDifference.solution2 : solution, 
					secondSolution, lastDifference ? lastDifference.newEdges : edges, differences.length);
			differences.push(difference);
			
			if (difference.to.length == 0)
				isComplete = true;
			//trace(secondSolution.toString());
			//edges = secondSolution.toEdges();
		}
		
		private function step2Opt(vec1:Vector.<Node>, vec2:Vector.<Node>):void 
		{
			for (var i:int = 0; i < vec1.length; i++) 
			{
				if (vec1[i] != vec2[i])
				{
					var secondIndex:int = vec1.indexOf(vec2[i]);
					var modified:Vector.<Node> = vec1.slice(0, i).concat(vec1.slice(i, secondIndex + 1).reverse());
					if (secondIndex != vec2.length -1)
						modified = modified.concat(vec1.slice(secondIndex + 1));
					for (var j:int = 0; j < modified.length; j++) 
					{
						vec1[j] = modified[j];
					}
					return;
				}
			}
		}
		
		private function step3Opt(vec1:Vector.<Node>, vec2:Vector.<Node>):void 
		{
			for (var i:int = 0; i < vec1.length; i++) 
			{
				if (vec1[i] != vec2[i])
				{
					var secondIndex:int = vec1.indexOf(vec2[i]);
					var modified1:Vector.<Node> = vec1.slice(0, i);
					var modified2:Vector.<Node> = vec1.slice(secondIndex);
					var ejected:Vector.<Node> = vec1.slice(i, secondIndex);
					if (vec2.indexOf(ejected[0]) > vec2.indexOf(ejected[ejected.length - 1]))
						ejected = ejected.reverse();
					var firstEjectedIndex:int = vec2.indexOf(ejected[0]);
					for (var k:int = 0; k < modified2.length; k++) 
					{
						if (vec2.indexOf(modified2[k]) == firstEjectedIndex - 1)
						{
							var result:Vector.<Node> = modified2.slice(0, k + 1).concat(ejected);
							if (k + 1 != modified2.length)
								result = result.concat(modified2.slice(k + 1));
							ejected = null;
							break;
						}
					}
					if	(!result)
					{
						result = modified2.concat(ejected);
					}
					result = modified1.concat(result);
						
					for (var j:int = modified1.length; j < result.length; j++) 
					{
						vec1[j] = result[j];
					}
					return;
				}
			}
		}
	}

}