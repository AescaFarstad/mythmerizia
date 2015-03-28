package minigames.tsp 
{
	
	public class PencilInteraction extends BaseInteraction 
	{
		public function PencilInteraction(model:TSPModel):void
		{
			super(model);
			pointInteractionPriority = 8;
		}
		
		public function pointHasTwoEdgesOrMore(point:Node):Boolean 
		{
			var counter:int = 0;
			for (var i:int = 0; i < edges.length; i++) 
			{
				if (edges[i].p1 == point || edges[i].p2 == point)
					counter++;
			}
			return counter >= 2;
		}
		
		override public function mouseDown(x:Number, y:Number):void 
		{
			var interactible:IInteractable = getBestInteractible(x, y);
			if (!interactable)
				workingPoint = null;
			else if (interactable is Edge)
			{
				trace("edge = ", edges.indexOf(interactable as Edge));
				edges.splice(edges.indexOf(interactable as Edge), 1);
				workingPoint = null;
			}
			else if (workingPoint)
			{
				addEdge(workingPoint, interactable as Node);
				workingPoint = interactable as Node;
				trace("index = ", workingPoint ? workingPoint.index : "");
			}
			else
			{
				workingPoint = interactable as Node;
				trace("index = ", workingPoint ? workingPoint.index : "");
			}
		}
		
		override public function loadSolution(solution:Vector.<Node>):void 
		{
			super.loadSolution(solution);
			interactable = null;
			workingPoint = null;
		}
	}

}