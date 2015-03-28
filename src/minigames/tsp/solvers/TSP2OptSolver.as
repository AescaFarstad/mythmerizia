package minigames.tsp.solvers 
{
	import minigames.tsp.Node;
	import minigames.tsp.TSPModel;
	
	public class TSP2OptSolver implements ITSPSolver 
	{
		private var solution:Vector.<Node>;
		private var model:TSPModel;
		
		public function TSP2OptSolver() 
		{
			
		}
		
		public function improve(solution:Vector.<Node>, model:TSPModel):void 
		{
			this.model = model;
			this.solution = solution;
			
			for (var p1:int = 0; p1 < solution.length; p1++) 
			{
				for (var shift:int = 0; shift < solution.length - 1; shift++) 
				{
					var p3:int = (p1 + shift) % solution.length;
					var p2:int = (p1 + 1) % solution.length;
					var p4:int = (p1 + shift + 1) % solution.length;
					if (p1 == p2 || p1 == p3 || p1 == p4 || p2 == p3 || p2 == p4 || p3 == p4)
						continue;
					var p1p2:Number = solution[p1].distanceTo(solution[p2].x, solution[p2].y);
					var p3p4:Number = solution[p3].distanceTo(solution[p4].x, solution[p4].y);
					var p1p3:Number = solution[p1].distanceTo(solution[p3].x, solution[p3].y);
					var p2p4:Number = solution[p2].distanceTo(solution[p4].x, solution[p4].y);
					var delta:Number = -p1p2 - p3p4 + p1p3 + p2p4;
					if (delta < 0)
					{
						//trace("will break", p1, "->", p2, ", ", p3, "->", p4);
						//trace("will create", p1, "->", p3, ", ", p2, "->", p4);
						//trace("inprove delta =", delta, "solution", model.getLength(solution));
						//trace(model.solutionToString(solution));
						if ((p4 - p2 + solution.length) % solution.length < (p2 - p4 + solution.length) % solution.length)
						{
							var from:int = p2;
							var to:int = p4;
						}
						else
						{
							from = p4;
							to = p2 + solution.length;
						}
						//trace("reversing from", from, "to", to);
						for (var i:int = from; i < to && (i < to - i + from); i++) 
						{
							var index1:int = i%solution.length
							var index2:int = (to - i + from - 1) % solution.length;
							//trace("swap", index1, index2);
							var tmp:Node = solution[index1];
							solution[index1] = solution[index2];
							solution[index2] = tmp;							
						}
						//trace("inprove end", model.getLength(solution));
						//trace(model.solutionToString(solution));
					}
				}
			}
			
		}
		
	}

}