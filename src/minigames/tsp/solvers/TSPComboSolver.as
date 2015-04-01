package minigames.tsp.solvers 
{
	import minigames.tsp.Node;
	import minigames.tsp.TSPModel;
	import minigames.tsp.TSPSolution;
	import util.HMath;
	
	public class TSPComboSolver implements ITSPSolver
	{
		private var model:TSPModel;
		private var solution:Vector.<Node>;
		
		public function TSPComboSolver() 
		{
			
		}
		
		private function initWithIndeferent():Vector.<Node> 
		{
			var result:Vector.<Node> = new Vector.<Node>();
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				result.push(model.nodes[i]);
			}
			return result;
		}
		
		public static function initWithRandom(model:TSPModel):Vector.<Node> 
		{
			var result:Vector.<Node> = new Vector.<Node>();
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				result.push(model.nodes[i]);
			}
			HMath.shuffleList(result);
			return result;
		}
		
		public function improve(solution:Vector.<Node>, model:TSPModel):void 
		{
			this.model = model;
			var numRestarts:int = 4;
			var num2Opts:int = 3;
			var bestSolution:Vector.<Node>;
			var bestDistance:Number = Number.POSITIVE_INFINITY;
			for (var i:int = 0; i < numRestarts; i++) 
			{
				//trace("============= RESTART =================");
				HMath.shuffleList(solution);
				for (var j:int = 0; j < num2Opts; j++) 
				{
					new TSP2OptSolver().improve(solution, model);
				}
				var distance:Number = TSPSolution.getSolutionLength(solution);
				if (distance < bestDistance)
				{
					bestDistance = distance;
					bestSolution = solution;
				}
				//trace("dist =", distance.toFixed());
			}
			for (var k:int = 0; k < solution.length; k++) 
			{
				solution[k] = bestSolution[k];
			}
		}
		
		private static function getInt(a:int = int.MIN_VALUE, b:int = int.MIN_VALUE):int
		{
			if (b == int.MIN_VALUE)
			{
				if (a == int.MIN_VALUE)
				{
					b = int.MAX_VALUE;
				}
				else
				{
					b = a;
					a = 0;
				}
			}
			return Math.floor(a + (b - a) * Math.random());
		}
		
		private function initWithGeedy():Vector.<Node> 
		{
			var result:Vector.<Node> = new Vector.<Node>();
			result.push(model.nodes[0]);
			while (result.length < model.nodes.length)
			{
				var bestPoint:Node;
				var bestDistance:Number = Number.POSITIVE_INFINITY;
				for (var i:int = 0; i < model.nodes.length; i++) 
				{
					var distance:Number = model.nodes[i].distanceTo(result[result.length - 1].x, result[result.length - 1].y);
					if (distance < bestDistance && result.indexOf(model.nodes[i]) == -1)
					{
						bestPoint = model.nodes[i];
						bestDistance = distance;
					}
				}
				result.push(bestPoint);
			}
			return result;
		}
		
	}

}