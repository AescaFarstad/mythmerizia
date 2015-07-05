package minigames.navgraph 
{
	
	public class PathElement 
	{
		
		public var node:NavNode;
		public var previousElement:PathElement;
		public var priority:Number;
		public var pathLength:Number;
		public var finalLength:Number;
		
		public function PathElement(node:NavNode, previousElement:PathElement = null, priority:Number = NaN, pathLength:Number = NaN)
		{
			this.pathLength = pathLength;
			this.priority = priority;
			this.previousElement = previousElement;
			this.node = node;
			
		}	
		
	}

}