package minigames.tsp 
{
	import minigames.tsp.solvers.ITSPSolver;
	import minigames.tsp.solvers.TSPComboSolver;
	
	public class AISolution
	{		
		private var _solution:Vector.<Node>;
		private var solutionLength:Number;
		private var model:TSPModel;
		
		public function AISolution(model:TSPModel) 
		{
			this.model = model;
			_solution = TSPComboSolver.initWithRandom(model);
			solutionLength = model.getLength(_solution);
		}
		
		public function get solution():Vector.<Node> 
		{
			return _solution;
		}
		
		public function improve(solver:ITSPSolver):void
		{
			solver.improve(_solution, model);
			solutionLength = model.getLength(_solution);
		}
		
	}

}