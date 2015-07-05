package minigames.navgraph 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import util.Heap;
	
	public class PathFinder 
	{
		private var space:NavSpace;
		
		public function PathFinder(space:NavSpace) 
		{
			this.space = space;			
		}
		
		public function getPath(from:Point, to:Point):Array
		{
			
			var fromCell:CellData = space.cellMatrix[int(from.y)][int(from.x)];
			var toCell:CellData = space.cellMatrix[int(to.y)][int(to.x)];
			
			//Invalid task
			if (toCell.isObstacle || fromCell.isObstacle)
				return null;
				
			//Within same mesh -> can move in a straight line
			for (var i:int = 0; i < fromCell.meshes.length; i++) 
			{
				if (fromCell.meshes[i] == toCell.meshes[i])
				{
					return [from, to];
				}
			}
			
			//Cut from teh rest
			if (toCell.nearestNodes.length == 0 || fromCell.nearestNodes.length == 0)
				return null;		
				
				
			//Find truly nearest nodes
			var nearestNodeFrom:NavNode;
			var nearestNodeTo:NavNode;
			if (fromCell.node)
			{
				elementsFrom = new <PathElement>[new PathElement(fromCell.node, null, 0, 0)];
			}
			else
			{
				var bestDistance:Number = Number.POSITIVE_INFINITY;
				for (i = 0; i < fromCell.nearestNodes.length; i++) 
				{
					var distance:Number = Math.pow(fromCell.nearestNodes[i].point.x - from.x, 2) + 
											Math.pow(fromCell.nearestNodes[i].point.y - from.y, 2);
					if (distance < bestDistance)
					{
						bestDistance = distance;
						nearestNodeFrom = fromCell.nearestNodes[i];
					}
				}
			}
			
			if (toCell.node)
			{
				elementsTo = new <PathElement>[new PathElement(toCell.node, null, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY)];
				elementsTo[0].finalLength = 0;
			}
			else
			{
				bestDistance = Number.POSITIVE_INFINITY;
				for (i = 0; i < toCell.nearestNodes.length; i++) 
				{
					distance = Math.pow(toCell.nearestNodes[i].point.x - to.x, 2) + 
											Math.pow(toCell.nearestNodes[i].point.y - to.y, 2);
					if (distance < bestDistance)
					{
						bestDistance = distance;
						nearestNodeTo = toCell.nearestNodes[i];
					}
				}
			}
			if (nearestNodeFrom == nearestNodeTo && nearestNodeFrom != null)
			{
				space.debugEdges = new Vector.<Edge>();
				if (space.isDirectlyVisible(from, to, NavSpace.UNIT_SIZE))
					return [from, to];
				else
					return [from, nearestNodeFrom, to];
			}
			
			//init path elements FROM
			if (!elementsFrom)
			{
				var elementsFrom:Vector.<PathElement> = new Vector.<PathElement>();
				var distanceFrom:Number = Math.sqrt(Math.pow(nearestNodeFrom.point.x - from.x, 2) + 
												Math.pow(nearestNodeFrom.point.y - from.y, 2));			
				var distanceTo:Number = Math.sqrt(Math.pow(nearestNodeFrom.point.x - to.x, 2) + 
												Math.pow(nearestNodeFrom.point.y - to.y, 2));
				var element:PathElement = new PathElement(nearestNodeFrom, null, distanceFrom + distanceTo, distanceFrom);
				elementsFrom.push(element);
				for (i = 0; i < nearestNodeFrom.links.length; i++) 
				{
					isSameMesh = false;
					for (l = 0; l < toCell.meshes.length; l++) 
					{
						if (fromCell.meshes[l] == nearestNodeFrom.links[i].cell.meshes[l])
						{
							isSameMesh = true;
							break;
						}
					}
					if (isSameMesh || space.isDirectlyVisible(from, nearestNodeFrom.links[i].point, NavSpace.UNIT_SIZE))
					{
						distanceFrom = Math.sqrt(Math.pow(nearestNodeFrom.links[i].point.x - from.x, 2) + 
													Math.pow(nearestNodeFrom.links[i].point.y - from.y, 2));
						distanceTo = Math.sqrt(Math.pow(nearestNodeFrom.links[i].point.x - to.x, 2) + 
														Math.pow(nearestNodeFrom.links[i].point.y - to.y, 2));
						element = new PathElement(nearestNodeFrom.links[i], null, distanceFrom + distanceTo, distanceFrom);					
						elementsFrom.push(element);
					}
				}
			}
			
			if (!elementsTo)
			{
				var elementsTo:Vector.<PathElement> = new Vector.<PathElement>();
				element = getElementWithNode(elementsFrom, nearestNodeTo);
				if (!element)
					element = new PathElement(nearestNodeTo, null, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
				element.finalLength = Math.sqrt(bestDistance);
				elementsTo.push(element);
				for (i = 0; i < nearestNodeTo.links.length; i++) 
				{
					var isSameMesh:Boolean = false;
					for (var l:int = 0; l < toCell.meshes.length; l++) 
					{
						if (toCell.meshes[l] == nearestNodeTo.links[i].cell.meshes[l])
						{
							isSameMesh = true;
							break;
						}
					}
					if (isSameMesh || space.isDirectlyVisible(to, nearestNodeTo.links[i].point, NavSpace.UNIT_SIZE))
					{
						distanceTo = Math.sqrt(Math.pow(nearestNodeTo.links[i].point.x - to.x, 2) + 
												Math.pow(nearestNodeTo.links[i].point.y - to.y, 2));
						element = getElementWithNode(elementsFrom, nearestNodeTo.links[i]);
						if (!element)
							element = new PathElement(nearestNodeTo.links[i], null, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
						element.finalLength = distanceTo;
						elementsTo.push(element);
					}
				}
			}
			
			//A*
			var path:Array = runAStar(elementsFrom, elementsTo, to);
			/*for (var l:int = 0; l < 100; l++) 
			{
				runAStar(elementsFrom, elementsTo, to);				
			}*/
			//Not connected
			if (!path)
			{
				//getPath(from, to);
				return null;
			}
			
			//Cut start and finish if there is an easier path
			for (var k:int = 1; k < path.length; k++) 
			{
				if (!space.isDirectlyVisible(from, new Point(path[k].x, path[k].y), NavSpace.UNIT_SIZE))
					break;
			}
			if (k != 0)
				path = path.slice(k - 1);
			/*	
			for (k = 1; k < path.length; k++) 
			{
				if (!space.isDirectlyVisible(to, new Point(path[path.length - k - 1].x, path[path.length - k - 1].y), NavSpace.UNIT_SIZE))
					break;
			}
			if (k < path.length)
				path = path.slice(0, k + 1);*/
			
			//Add the end points
			if (path && (path.length == 0 || path[0].x != from.x || path[0].y != from.y))
				path.unshift(from);
			if (path && (path.length == 0 || path[path.length - 1].x != to.x || path[path.length - 1].y != to.y))
				path.push(to);
			return path;
		}
		
		private function getElementWithNode(elements:Vector.<PathElement>, node:NavNode):PathElement
		{
			for (var i:int = 0; i < elements.length; i++) 
			{
				if (elements[i].node == node)
					return elements[i];
			}
			return null;
		}
		
		//одной и той же ноде должен соответствовать один и тот же элемент
		private function runAStar(from:Vector.<PathElement>, to:Vector.<PathElement>, target:Point):Array 
		{
			var targetNode:NavNode = new NavNode(null);
			targetNode.point = target;
			var queue:Heap = new Heap(space.nodes.length, compare);
			var elementByNode:Dictionary = new Dictionary();
			for (i = 0; i < from.length; i++) 
			{
				queue.push(from[i]);
				elementByNode[from[i].node] = from[i];
				
			}
			for (i = 0; i < to.length; i++) 
			{
				elementByNode[to[i].node] = to[i];				
			}
			while (queue.length > 0)
			{
				var element:PathElement = queue.pop();
				//elementByNode[element.node] = null;
				if (element.node == targetNode)
					break;
				if (isNaN(element.finalLength))
				{
					var iterVec:Vector.<NavNode> = element.node.links;
				}
				else
				{
					iterVec = element.node.links.slice();
					iterVec.push(targetNode);
				}
				for (var i:int = 0; i < iterVec.length; i++) 
				{
					var newLength:Number = element.pathLength + (i < element.node.distances.length ? element.node.distances[i] : element.finalLength);
					var priority:Number = newLength + Math.sqrt(Math.pow(iterVec[i].point.x - target.x, 2) + 
																Math.pow(iterVec[i].point.y - target.y, 2));
					var existingElement:PathElement = elementByNode[iterVec[i]];
					if (existingElement)
					{
						if (existingElement.pathLength > newLength)
						{
							//check if equal and the last leap is greater. shouldn't ever happen. I think...
							existingElement.pathLength = newLength;
							existingElement.previousElement = element;
							existingElement.priority = priority;
							if (queue.contains(existingElement))
								queue.tryToAdvance(existingElement);
							else
								queue.push(existingElement);
						}
					}
					else
					{
						var newElement:PathElement = new PathElement(iterVec[i], element, priority, newLength);
						queue.push(newElement);
						elementByNode[iterVec[i]] = newElement;
					}
				}
			}
			
			if (queue.length == 0 && element.node != targetNode)
				return null;
				
			//trace("A* length", element.pathLength);
			var result:Array = [element.node];
			while (element.previousElement)
			{
				element = element.previousElement;
				result.push(element.node);
			}
			result.reverse();
			
			return result;
			
			function compare(a:PathElement, b:PathElement):int 
			{
				if (a.priority == b.priority)
					return 0;
				return a.priority < b.priority ? 1 : -1;
			}
		}
		
	}

}
