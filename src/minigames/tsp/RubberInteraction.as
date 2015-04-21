package minigames.tsp 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import util.DebugRug;
	import util.HMath;
	
	public class RubberInteraction extends BaseInteraction 
	{
		public var dragNode:Node;
		public var phantomEdges:Vector.<Edge>;
		public var sourceEdge:Edge;
		private var rubberMaxAngle:Number = Math.PI / 5;
		public var thirdPoints:Vector.<Point>;
		public var thirdEdges:Vector.<Edge>;
		
		public var pairings:Vector.<Object>;
		public var dragEdges:Vector.<Edge>;
		public var intersectionEsists:Boolean;
		//public var intersectionPoint:Point;
		
		public function RubberInteraction(model:TSPModel) 
		{
			super(model);
			pointInteractionPriority = 4;
		}
		
		override public function updateInteractable(x:Number, y:Number, timePassed:int):void 
		{
			if (!dragNode)
				super.updateInteractable(x, y, timePassed);
			else
			{
				dragNode.x = x;
				dragNode.y = y;
				buildDragEdgesSkewedParabola();
				checkForIntersections();
				updatePhantomEdges();
			}
		}
		
		private function checkForIntersections():void 
		{
			intersectionEsists = false;
			for (var i:int = 0; i < dragEdges.length; i++) 
			{
				for (var j:int = 0; j < edges.length; j++) 
				{
					if (dragEdges[i].intersects(edges[j]))
					{
						intersectionEsists = true;
						//intersectionPoint = HMath.linesIntersection(dragEdges[i].p1.point, dragEdges[i].p2.point, edges[j].p1.point, edges[j].p2.point);
						return;
					}
				}
			}
		}
		
		private function buildDragEdgesSkewedParabola():void 
		{
			dragEdges = new Vector.<Edge>();
			dragEdges.push(sourceEdge);
			
			var sourceCenter:Node = new Node((sourceEdge.p1.x + sourceEdge.p2.x) / 2, (sourceEdge.p1.y + sourceEdge.p2.y) / 2);
			
			var distanceToSourceEdge:Number = HMath.distanceFromPointToSegment(dragNode.x, dragNode.y, 
					sourceEdge.p1.x, sourceEdge.p1.y, sourceEdge.p2.x, sourceEdge.p2.y)
			var divCount:int = distanceToSourceEdge < 50 ? 0 : HMath.linearInterp(0, 5, 100, 20, distanceToSourceEdge);
			var subGrowth:Number = HMath.nonlinearInterp(0, 1.5, 25, 1.20, 0.35, divCount);
			var edge:Edge = new Edge(dragNode, sourceEdge.p1);
			dragEdges = dragEdges.concat(parabolizeEdge(dragNode, edge, sourceCenter, subGrowth, divCount));
			edge = new Edge(dragNode, sourceEdge.p2);
			dragEdges = dragEdges.concat(parabolizeEdge(dragNode, edge, sourceCenter, subGrowth, divCount));
		}
		
		private function parabolizeEdge(dragNode:Node, edge:Edge, sourceCenter:Node, subGrowth:Number, divCount:int):Vector.<Edge> 
		{
			var result:Vector.<Edge> = new Vector.<Edge>();
			var theOtherPoint:Node = edge.theOtherPoint(dragNode);
			var centerEdge:Edge = new Edge(dragNode, sourceCenter);
			var scalar:Number = (dragNode.x - theOtherPoint.x) * (dragNode.x - sourceCenter.x) + 
								(dragNode.y - theOtherPoint.y) * (dragNode.y - sourceCenter.y);
			var lengths:Number = edge.length * centerEdge.length;
			
			var phi:Number = Math.asin(scalar / lengths);
			var alpha:Number = phi / (divCount + 1);
			var b1:Number = edge.length / Math.pow(subGrowth, divCount);
			//var a1:Number = b1 * b1 + subGrowth * subGrowth * b1 * b1 - 2 * subGrowth * b1 * b1 * Math.cos(phi);
			var lastNode:Node = dragNode;
			var sign:int = (dragNode.x - theOtherPoint.x) * (dragNode.y - sourceCenter.y) - 
								(dragNode.x - sourceCenter.x) * (dragNode.y - theOtherPoint.y) > 0 ? -1 : 1;
			
			var currentB:Number = b1;
			var point:Point = HMath.rotateVector((sourceCenter.x - dragNode.x), (sourceCenter.y - dragNode.y), Math.PI / 2 * sign);
			point = HMath.rotateVector(point.x, point.y, -alpha * sign);
			point = HMath.normalizeVector(point.x, point.y);
			
			//var debugStr:String = "";
			for (var i:int = 0; i < divCount; i++) 
			{
				//debugStr += ", b" + i.toString() + " = " + currentB.toFixed(1);
				var multi:Number = i == 0 ? 0.5 : 1;
				var newNode:Node = new Node(dragNode.x + point.x * currentB * multi, dragNode.y + point.y * currentB * multi);
				result.push(new Edge(lastNode, newNode));
				result[result.length - 1].index = i;
				
				lastNode = newNode;
				point = HMath.rotateVector(point.x, point.y, -alpha * sign);
				currentB *= subGrowth;
			}
			//debugStr += ", b" + i.toString() + " = " + currentB.toFixed(1);
			result.push(new Edge(lastNode, theOtherPoint));
			result[result.length - 1].index = i;
			/*
			for (var j:int = 0; j < result.length; j++) 
			{
				debugStr += ", " + j.toString() + " = " + result[j].length;
			}
			trace(debugStr);*/
			return result;
		}
		/*
		private function buildDragEdgesTriangle():void 
		{
			dragEdges = new Vector.<Edge>();
			dragEdges.push(new Edge(sourceEdge.p1, dragNode));
			dragEdges.push(new Edge(dragNode, sourceEdge.p2));
			dragEdges.push(sourceEdge);
		}*/
		
		private function updatePhantomEdges():void 
		{
			if (intersectionEsists)
			{
				phantomEdges = new <Edge>[sourceEdge];
				return;
			}
			var innerNodes:Vector.<Node> = findAllNodesInsidePolytop(TSPSolution.edgesToNodes(dragEdges));
			if (innerNodes.indexOf(sourceEdge.p1) == -1)
				innerNodes.push(sourceEdge.p1);
			if (innerNodes.indexOf(sourceEdge.p2) == -1)
				innerNodes.push(sourceEdge.p2);
			for (var j:int = 0; j < edges.length; j++) 
			{
				if (edges[j].p1 != sourceEdge.p1 && edges[j].p1 != sourceEdge.p2)
				{
					if (innerNodes.indexOf(edges[j].p1) != -1)
					{
						intersectionEsists = true;
						phantomEdges = new <Edge>[sourceEdge];
						return;
					}
				}
				
				if (edges[j].p2 != sourceEdge.p1 && edges[j].p2 != sourceEdge.p2)
				{
					if (innerNodes.indexOf(edges[j].p2) != -1)
					{
						intersectionEsists = true;
						phantomEdges = new <Edge>[sourceEdge];
						return;
					}
				}
			}
			var hull:Vector.<Edge> = getConvexHull(innerNodes);
			for (var i:int = 0; i < hull.length; i++) 
			{
				if ((hull[i].p1 == sourceEdge.p1 || hull[i].p1 == sourceEdge.p2) && 
					(hull[i].p2 == sourceEdge.p1 || hull[i].p2 == sourceEdge.p2))
				{
					hull.splice(i, 1);
					break;
				}
			}
			
			hull = subDivideEdges(subDivideEdges(hull));
			
			phantomEdges = hull;
		}
		
		private function subDivideEdges(edgeVec:Vector.<Edge>):Vector.<Edge> 
		{
			pairings = new Vector.<Object>();
			thirdPoints = new Vector.<Point>();
			thirdEdges = new Vector.<Edge>();
			var newEdges:Vector.<Edge> = new Vector.<Edge>();
			var removedEdges:Vector.<Edge> = new Vector.<Edge>();
			for (var i:int = 0; i < edgeVec.length; i++) 
			{
				var thrirdPoint:Point = HMath.pointOnPerpendicularBisector(
						edgeVec[i].p1.x, edgeVec[i].p1.y, edgeVec[i].p2.x, edgeVec[i].p2.y, 
						Math.sin(rubberMaxAngle) * edgeVec[i].length / 2, 1);
				thirdPoints.push(thrirdPoint);
				thirdEdges.push(new Edge(new Node((edgeVec[i].p1.x + edgeVec[i].p2.x) / 2, 
													(edgeVec[i].p1.y + edgeVec[i].p2.y) / 2),
												new Node(thrirdPoint.x, thrirdPoint.y))); 
				thirdEdges.push(edgeVec[i]); 
				var innerNodes:Vector.<Node> = findAllNodesInsideTriangle(edgeVec[i].p1.point, edgeVec[i].p2.point, thrirdPoint);		
				innerNodes.sort(sortOnDistanceToEdge);
				for (var j:int = 0; j < innerNodes.length; j++) 
				{
					
					var nodeBelogsToEdges:Boolean = false;
					if (getEdgeWithPoint(innerNodes[j]))
						continue;
					for (var m:int = 0; m < edgeVec.length; m++) 
					{
						if (innerNodes[j] == edgeVec[m].p1 || innerNodes[j] == edgeVec[m].p2)
						{
							nodeBelogsToEdges = true;
							break;
						}
					}
					if (nodeBelogsToEdges)
						continue;
						
						
					var thisDistance:Number = HMath.distanceFromPointToLine(innerNodes[j].x, innerNodes[j].y, 
							edgeVec[i].p1.x, edgeVec[i].p1.y, edgeVec[i].p2.x, edgeVec[i].p2.y);
					var foundBetterEdge:Boolean = false;
					for (var k:int = 0; k < edgeVec.length; k++) 
					{
						if (edgeVec[k] != edgeVec[i] && 
								HMath.distanceFromPointToSegment(innerNodes[j].x, innerNodes[j].y, 
										edgeVec[k].p1.x, edgeVec[k].p1.y, edgeVec[k].p2.x, edgeVec[k].p2.y) < thisDistance)
						{
							foundBetterEdge = true;
							pairings.push( { x1:innerNodes[j].x, y1:innerNodes[j].y, 
										x2:(edgeVec[k].p1.x + edgeVec[k].p2.x) / 2, y2:(edgeVec[k].p1.y + edgeVec[k].p2.y) / 2 } );
							break;
						};
					}					
					if (!foundBetterEdge)
					{
						insertIntoEdge(edgeVec[i], innerNodes[j]);
						break;
					}
				}
			}
			
			for (var l:int = 0; l < edgeVec.length; l++) 
			{
				if (removedEdges.indexOf(edgeVec[l]) == -1)
					newEdges.push(edgeVec[l]);
			}
			
			return newEdges;
			
			//--------------------------------------------------------------------------------------
			function insertIntoEdge(edge:Edge, newNode:Node):void
			{
				removedEdges.push(edge);
				newEdges.push(new Edge(edge.p1, newNode));
				newEdges.push(new Edge(newNode, edge.p2));
			}
			
			function sortOnDistanceToEdge(a:Node, b:Node):int
			{
				return HMath.distanceFromPointToLine(a.x, a.y, edgeVec[i].p1.x, edgeVec[i].p1.y, edgeVec[i].p2.x, edgeVec[i].p2.y) >
						HMath.distanceFromPointToLine(b.x, b.y, edgeVec[i].p1.x, edgeVec[i].p1.y, edgeVec[i].p2.x, edgeVec[i].p2.y) ? 1 : -1;
			}
		}
		
		private function findAllNodesInsidePolytop(polytop:Vector.<Node>):Vector.<Node> 
		{
			var result:Vector.<Node> = new Vector.<Node>();
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				if (isInside(model.nodes[i]))
					result.push(model.nodes[i]);
			}
			return result;
			
			function isInside(node:Node):Boolean
			{
				var b1:Boolean = (node.x - polytop[1].x) * (polytop[0].y - polytop[1].y) - (polytop[0].x - polytop[1].x) * (node.y - polytop[1].y) < 0;
				for (var j:int = 1; j < polytop.length - 1; j++) 
				{
					var thisB:Boolean = (node.x - polytop[j+1].x) * (polytop[j].y - polytop[j+1].y) - (polytop[j].x - polytop[j+1].x) * (node.y - polytop[j+1].y) < 0;
					if (thisB != b1)
						return false;
				}
				thisB = (node.x - polytop[0].x) * (polytop[polytop.length - 1].y - polytop[0].y) - (polytop[polytop.length - 1].x - polytop[0].x) * (node.y - polytop[0].y) < 0;
				if (thisB != b1)
					return false;
				return true;
			}
		}
		
		private function findAllNodesInsideTriangle(p1:Point, p2:Point, p3:Point):Vector.<Node> 
		{
			var result:Vector.<Node> = new Vector.<Node>();
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				if (isInside(model.nodes[i]))
					result.push(model.nodes[i]);
			}
			return result;
			
			function isInside(node:Node):Boolean
			{
				var b1:Boolean = (node.x - p2.x) * (p1.y - p2.y) - (p1.x - p2.x) * (node.y - p2.y) < 0;
				var b2:Boolean = (node.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (node.y - p3.y) < 0;
				var b3:Boolean = (node.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (node.y - p1.y) < 0;

				return ((b1 == b2) && (b2 == b3));
			}
		}
		
		override public function mouseDown(x:Number, y:Number):void 
		{
			var interactible:IInteractable = getBestInteractible(x, y);
			if (interactable is Node)
			{
				if (edges.length <= 3)
					return;
				var edgesWithNode:Vector.<Edge> = getAllEdgesWithNode(interactable as Node);
				removeAllEdgesWithNode(interactable as Node);
				var newEdge:Edge = addEdge(edgesWithNode[0].theOtherPoint(interactable as Node), edgesWithNode[1].theOtherPoint(interactable as Node));
				/*phantomEdges = new Vector.<Edge>();
				phantomEdges.push(newEdge);
				dragPoint = new Point(x, y);
				workingNode1 = newEdge.p1;
				workingNode2 = newEdge.p2;*/
			}
			else if (interactable is Edge)
			{
				phantomEdges = new Vector.<Edge>();
				phantomEdges.push(interactable as Edge);
				edges.splice(edges.indexOf(interactable as Edge), 1);
				dragNode = new Node(x, y);
				sourceEdge = (interactable as Edge);
				//trace(DebugRug.getCurrentStack("removed" + sourceEdge));
			}
			else
			{
				
			}
		}
		
		override public function mouseUp(x:Number, y:Number):void 
		{
			if (phantomEdges)
			{
				for (var i:int = 0; i < phantomEdges.length; i++) 
				{
					edges.push(phantomEdges[i]);
				}
			}
			dragNode = null;
			phantomEdges = null;
			sourceEdge = null;
			dragEdges = null;
			intersectionEsists = false;
			//intersectionPoint = null;
			edgesToSolutionWithoutUpdate();
		}
		
		override protected function getBestInteractible(x:Number, y:Number):IInteractable 
		{
			var inter:IInteractable = super.getBestInteractible(x, y);
			if (inter is Node)
				return existsEdgeWith(inter as Node) && edges.length > 3 ? inter : null;
			return inter;
		}
		
		public function subDivide():void 
		{
			onSolutionChange();
			edges = subDivideEdges(edges);
		}
		
		override public function loadConvexHull():void
		{			
			edges = subDivideEdges(subDivideEdges(getConvexHull(model.nodes)));
			edgesToSolutionWithoutUpdate();
		}
		/*
		public function normalizeEdges():void
		{
			onSolutionChange();
			var result:Vector.<Node> = new Vector.<Node>();
			var p:Node = edges[0].p1;
			var edge:Edge = edges[0];
			
			while (result.indexOf(edge.theOtherPoint(p)) == -1)
			{
				result.push(p);
				p = edge.theOtherPoint(p);
				edge = getEdgeWithPoint(p, edge);
			}
			result.push(p);
			edges = pointSequenceToEdges(result);
			solutionUpToDate = false;
		}*/
		
	}

}