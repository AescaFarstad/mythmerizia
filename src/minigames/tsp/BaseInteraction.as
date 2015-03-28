package minigames.tsp
{
	import flash.geom.Point;
	import minigames.tsp.solvers.TSP2OptSolver;
	import mx.core.EdgeMetrics;
	import util.HMath;
	
	public class BaseInteraction 
	{
		public static const INTERACTION_RADIUS:Number = 18;
		
		protected var pointInteractionPriority:int;
		
		public var interactable:IInteractable;
		public var workingPoint:Node;/*
		public var nearestInteractiblePoint:Node;
		public var nearestInteractibleEdge:Node;*/
		public var model:TSPModel;
		public var edges:Vector.<Edge>;
		protected var solutionLength:Number;
		protected var solutionUpToDate:Boolean;
		protected var _solution:Vector.<Node>;
		protected var _errorMessage:String;
		
		public function BaseInteraction(model:TSPModel) 
		{
			this.model = model;
			edges = new Vector.<Edge>();
		}
		
		public function get solution():Vector.<Node>
		{
			if (!solutionUpToDate)
			{
				_solution = null;
				_errorMessage = null;
				for (var i:int = 0; i < model.nodes.length; i++) 
				{
					var num:int = getNumEdges(model.nodes[i]);
					if (num < 2)
						_errorMessage = "Не все точки включены в кольцо";
					if (num > 2)
						_errorMessage = "Одна точка не может быть соединена с более чем двумя соседями";				
				}
				if (_errorMessage)
					return null;
				var result:Vector.<Node> = new Vector.<Node>();
				var p:Node = model.nodes[0];
				var edge:Edge = getEdgeWithPoint(p, null);
				
				while (result.indexOf(edge.theOtherPoint(p)) == -1)
				{
					result.push(p);
					p = edge.theOtherPoint(p);
					edge = getEdgeWithPoint(p, edge);
				}
				result.push(p);
				
				if (result.length != model.nodes.length)
					_errorMessage = "Кольцо должно быть одним";
				else
					_solution = result;
			}			
			return _solution;
		}
		
		public function addEdge(p1:Node, p2:Node):Edge 
		{			
			if (p1 != p2)
			{
				if (!edgeExists(p1, p2))
				{
					var edge:Edge = new Edge(p1, p2);
					edges.push(edge);
					solutionUpToDate = false;
					return edge;
				}
			}
			return null;
		}
		
		protected function edgeExists(x:Node, y:Node):Boolean 
		{
			for (var i:int = 0; i < edges.length; i++) 
			{
				if (edges[i].p1 == x && edges[i].p2 == y || edges[i].p1 == y && edges[i].p2 == x)
					return true;
			}
			return false;
		}
		
		public function getFeedback():String 
		{			
			var sol:Vector.<Node> = solution;
			if (!sol)
				return _errorMessage;
				
			var length:Number = model.getLength(solution);			
			return "Длинна пути: " + length.toFixed();
		}
		
		public function updateInteractable(x:Number, y:Number):void 
		{
			interactable = getBestInteractible(x, y);			
		}
		
		public function mouseDown(x:Number, y:Number):void 
		{
			
		}
		
		public function mouseUp(x:Number, y:Number):void 
		{
			
		}
		
		public function getEdgeWithPoint(p:Node, tabu:Edge = null, edgeVec:Vector.<Edge> = null ):Edge 
		{
			edgeVec ||= edges;
			for (var i:int = 0; i < edgeVec.length; i++) 
			{
				if ((edgeVec[i].p1 == p || edgeVec[i].p2 == p) && tabu != edgeVec[i])
					return edgeVec[i];
			}
			return null;
		}
		
		protected function getNumEdges(node:Node):int 
		{
			var count:int = 0;
			for (var i:int = 0; i < edges.length; i++) 
			{
				if (edges[i].p1 == node || edges[i].p2 == node)
					count++;
			}
			return count;
		}
		
		protected function existsEdgeWith(node:Node):Boolean 
		{
			for (var i:int = 0; i < edges.length; i++) 
			{
				if (edges[i].p1 == node || edges[i].p2 == node)
					return true;
			}
			return false;
		}
		
		protected function getBestInteractible(x:Number, y:Number):IInteractable 
		{
			var bestInter:IInteractable;
			var bestPoint:Node = model.getNearestPoint(x, y);
			var bestDistance:Number = bestPoint.distanceTo(x, y);
			if (bestDistance < INTERACTION_RADIUS)
				bestInter = bestPoint;
			
			bestDistance -= pointInteractionPriority;
			for (var i:int = 0; i < edges.length; i++) 
			{
				var distance:Number = edges[i].distanceToPoint(x, y);
				if (distance < bestDistance && distance < INTERACTION_RADIUS)
				{
					bestDistance = distance;
					bestInter = edges[i];
				}
			}
			return bestInter;
		}
		
		public function loadSolution(solution:Vector.<Node>):void
		{			
			edges = pointSequenceToEdges(solution);
			solutionUpToDate = false;
		}
		
		public function improveAIWith2Opt():void 
		{
			if (solution)
			{
				new TSP2OptSolver().improve(solution, model);
				solutionLength = model.getLength(solution);
			}
		}
		
		public function loadConvexHull():void
		{			
			edges = getConvexHull(model.nodes);
			solutionUpToDate = false;
		}
		
		protected function pointSequenceToEdges(points:Vector.<Node>):Vector.<Edge>
		{
			var result:Vector.<Edge> = new Vector.<Edge>();
			for (var i:int = 1; i < points.length; i++) 
			{
				result.push(new Edge(points[i - 1], points[i]));
			}
			result.push(new Edge(points[points.length - 1], points[0]));
			return result;
		}
		
		protected function edgesToPointSequence(points:Vector.<Edge>):Vector.<Node>
		{
			var result:Vector.<Node> = new Vector.<Node>();
			var p:Node = points[0].p1;
			var edge:Edge = points[0];
			
			while (result.indexOf(edge.theOtherPoint(p)) == -1)
			{
				result.push(p);
				p = edge.theOtherPoint(p);
				edge = getEdgeWithPoint(p, edge, points);
			}
			result.push(p);
			return result;
		}
		
		protected function getConvexHull(points:Vector.<Node>):Vector.<Edge>
		{
			if (points.length <= 3)
			{
				return 	pointSequenceToEdges(points);
			}
			var edgePoint:Node = null;
			for (var i:int = 0; i < points.length; i++) 
			{
				if (!edgePoint || points[i].x < edgePoint.x)
					edgePoint = points[i];
			}
			
			var hullPoints:Vector.<Node> = new Vector.<Node>();
			var thisPoint:Node;
			nextPoint = edgePoint;
			var angle:Number = -Math.PI / 2;
			while (!thisPoint || nextPoint != edgePoint)
			{
				thisPoint = nextPoint;
				var nextPoint:Node = findPointByCircularDirection(points, thisPoint, angle, -1);				
				angle = Math.atan2(nextPoint.y - thisPoint.y, nextPoint.x - thisPoint.x);
				hullPoints.push(thisPoint);
			}
			return pointSequenceToEdges(hullPoints);
		}
		
		protected function findPointByCircularDirection(points:Vector.<Node>, fromPoint:Node, angle:Number, direction:int):Node 
		{
			var bestPoint:Node;
			var bestAngle:Number = Math.PI;
			for (var i:int = 0; i < points.length; i++) 
			{
				if (points[i] == fromPoint)
					continue;
				var ind:int = points[i].index;
				var thisAngle:Number = -HMath.angleShortestDelta(angle, Math.atan2(points[i].y - fromPoint.y, points[i].x - fromPoint.x));
				//trace("point", ind, "is at ", thisAngle.toFixed(2));
				if ((thisAngle > 0) == (direction > 0) && Math.abs(thisAngle) < bestAngle)
				{
					bestAngle = Math.abs(thisAngle);
					bestPoint = points[i];
				}
			}
			return bestPoint;
		}
		
		protected function removeAllEdgesWithNode(node:Node):void 
		{
			for (var i:int = 0; i < edges.length; i++) 
			{
				if (edges[i].p1 == node || edges[i].p2 == node)
				{
					edges.splice(i, 1);
					i--;
				}
			}
		}
		
		protected function getAllEdgesWithNode(node:Node): Vector.<Edge> 
		{
			var result:Vector.<Edge> = new Vector.<Edge>();
			for (var i:int = 0; i < edges.length; i++) 
			{
				if (edges[i].p1 == node || edges[i].p2 == node)
				{
					result.push(edges[i]);
				}
			}
			return result;
		}
		
	}

}