package minigames.tsp 
{
	import minigames.tsp.solvers.ITSPSolver;
	
	public class TSPSolution 
	{
		private var model:TSPModel;
		private var _length:Number;
		public var vec:Vector.<Node> = new Vector.<Node>();
		public var onChange:Function;
		
		public function TSPSolution(model:TSPModel) 
		{
			this.model = model;
			
		}
		
		public function improve(solver:ITSPSolver):void
		{
			solver.improve(vec, model);
			dispatchChange();
		}
		
		private function dispatchChange():void 
		{
			_length = getSolutionLength(vec);
			if (onChange != null)
				onChange();			
		}
		
		public static function getSolutionLength(solution:Vector.<Node>):Number 
		{
			var result:Number = 0;
			for (var i:int = 1; i < solution.length; i++) 
			{
				result += solution[i - 1].distanceTo(solution[i].x, solution[i].y);
			}
			if (solution.length > 0)
				result += solution[solution.length - 1].distanceTo(solution[0].x, solution[0].y);
			return result;
		}
		
		public function get length():Number
		{
			return _length;
		}
		
		public function fromEdges(edges:Vector.<Edge>):void
		{			
			vec = edgesToNodes(edges);
			dispatchChange();
		}
		
		public static function edgesToNodes(edges:Vector.<Edge>):Vector.<Node>
		{
			var result:Vector.<Node> = new Vector.<Node>();
			if (edges.length == 0)
				return result;
				
			var p:Node = edges[0].p1;
			var edge:Edge = edges[0];
			
			while (result.indexOf(edge.theOtherPoint(p)) == -1)
			{
				result.push(p);
				p = edge.theOtherPoint(p);
				edge = getEdgeWithPoint(p, edge, edges);
			}
			result.push(p);
			return result;
		}
		
		private static function getEdgeWithPoint(p:Node, tabu:Edge, edgeVec:Vector.<Edge>):Edge 
		{
			for (var i:int = 0; i < edgeVec.length; i++) 
			{
				if ((edgeVec[i].p1 == p || edgeVec[i].p2 == p) && tabu != edgeVec[i])
					return edgeVec[i];
			}
			return null;
		}
		
		public function toEdges():Vector.<Edge>
		{
			return nodesToEdges(vec);
		}
		
		public static function nodesToEdges(nodes:Vector.<Node>):Vector.<Edge>
		{
			var result:Vector.<Edge> = new Vector.<Edge>();
			for (var i:int = 1; i < nodes.length; i++) 
			{
				result.push(new Edge(nodes[i - 1], nodes[i]));
			}
			if (nodes.length > 0)
				result.push(new Edge(nodes[nodes.length - 1], nodes[0]));
			return result;
		}
		
		public function toString():String
		{
			var arr:Array = [];
			for (var i:int = 0; i < vec.length; i++) 
			{
				if (i % 10 == 9)
					arr.push(" | ");
				arr.push(vec[i].index);
			}
			return arr.join(", ");
		}
		
		public function isValid():Boolean 
		{
			return vec.length == model.nodes.length;
		}
	}

}