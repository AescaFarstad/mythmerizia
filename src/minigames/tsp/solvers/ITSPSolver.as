package minigames.tsp.solvers 
{
	import minigames.tsp.Node;
	import minigames.tsp.TSPModel;
	
	public interface ITSPSolver 
	{
		function improve(solution:Vector.<Node>, model:TSPModel):void;
	}
	
}