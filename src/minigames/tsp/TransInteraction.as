package minigames.tsp 
{
	import flash.events.Event;
	
	public class TransInteraction extends BaseInteraction 
	{
		private static const UPDATE_PERIOD:int = 1000;
		
		private var callback:Function;
		private var lastUpdateStamp:int;
		private var time:int;
		private var isComplete:Boolean;
		private var targetSolution:TSPSolution;
		private var differences:Vector.<SolutionDifference> = new Vector.<SolutionDifference>();
		
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
			if (lastUpdateStamp < time - UPDATE_PERIOD)
			{
				if (isComplete)
					callback();
				else
				{
					update();
					lastUpdateStamp = time;
				}
			}
		}
		
		private function update():void 
		{
			var secondSolution:TSPSolution = new TSPSolution(model);
			var lastDifference:SolutionDifference = differences.length > 0 ? differences[differences.length - 1] : null;
			secondSolution.fromSolution(lastDifference ? lastDifference.solution2 : solution);
			step2Opt(secondSolution.vec, targetSolution.vec);
			var difference:SolutionDifference = new SolutionDifference(lastDifference ? lastDifference.solution2 : solution, secondSolution, lastDifference ? lastDifference.newEdges : edges);
			differences.push(difference);
			
			if (difference.to.length == 0)
				isComplete = true;
			//trace(secondSolution.toString());
			edges = secondSolution.toEdges();
		}
		
		private function step2Opt(vec1:Vector.<Node>, vec2:Vector.<Node>):void 
		{
			/*if (vec1[0] != vec2[0])
			{
				var index:int = vec2.indexOf(vec1[0]);
				var modified:Vector.<Node> = vec2.slice(index).concat(vec2.slice(0, index));
				for (var i:int = 0; i < modified.length; i++) 
				{
					vec1[i] = modified[i];
				}
			}*/
			for (var i:int = 0; i < vec1.length; i++) 
			{
				if (vec1[i] != vec2[i])
				{
					var secondIndex:int = vec1.indexOf(vec2[i]);
					//var skipReturn:Boolean = (i == 1) && (secondIndex == vec2.length - 1);
					var modified:Vector.<Node> = vec1.slice(0, i).concat(vec1.slice(i, secondIndex + 1).reverse());
					if (secondIndex != vec2.length -1)
						modified = modified.concat(vec1.slice(secondIndex + 1));
					for (var j:int = 0; j < modified.length; j++) 
					{
						vec1[j] = modified[j];
					}
					//if (!skipReturn)
						return;
				}
			}
		}
		
	}

}