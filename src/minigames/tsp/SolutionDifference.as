package minigames.tsp 
{
	
	public class SolutionDifference 
	{
		public var from:Vector.<Edge> = new Vector.<Edge>();
		public var to:Vector.<Edge> = new Vector.<Edge>();
		public var newEdges:Vector.<Edge> = new Vector.<Edge>();
		public var solution1:TSPSolution;
		public var solution2:TSPSolution;
		
		public function SolutionDifference(solution1:TSPSolution, solution2:TSPSolution, edges:Vector.<Edge>) 
		{
			this.solution2 = solution2;
			this.solution1 = solution1;
			var solutionVec:Vector.<Node> = solution2.vec;
			newEdges = edges.slice();
			for (var i:int = 0; i < solutionVec.length; i++) 
			{
				var next:int = (i + 1) % solutionVec.length;
				if (!edgesContain(edges, solutionVec[i], solutionVec[next]))
				{
					var edge:Edge = new Edge(solutionVec[i], solutionVec[next]);
					to.push(edge);
					newEdges.push(edge);
				}
			}
			
			for (i = 0; i < edges.length; i++) 
			{
				if (!solutionContains(solutionVec, edges[i]))
				{
					from.push(edges[i]);
					newEdges.splice(newEdges.indexOf(edges[i]), 1);
				}
			}
			
		}
		
		private function solutionContains(solutionVec:Vector.<Node>, edge:Edge):Boolean 
		{
			for (var i:int = 0; i < solutionVec.length; i++) 
			{
				var nextindex:int = (i + 1) % solutionVec.length;
				if ((solutionVec[i] == edge.p1 || solutionVec[i] == edge.p2) &&
					(solutionVec[nextindex] == edge.p1 || solutionVec[nextindex] == edge.p2))
				{
					return true;
				}
			}
			return false;
		}
		
		private function edgesContain(edges:Vector.<Edge>, node1:Node, node2:Node):Boolean 
		{
			for (var i:int = 0; i < edges.length; i++) 
			{
				if ((edges[i].p1 == node1 || edges[i].p2 == node1) && 
					(edges[i].p1 == node2 || edges[i].p2 == node2))
				{
					return true;
				}
			}
			return false;
		}
		
	}

}