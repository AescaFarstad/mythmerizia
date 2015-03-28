package minigames.tsp 
{
	import flash.geom.Point;
	
	public class Node implements IInteractable
	{
		public var x:Number;
		public var y:Number;
		public var index:int = -1;
		public var point:Point;
		
		
		
		public function Node(x:Number = 0, y:Number = 0 ) 
		{
			this.y = y;
			this.x = x;
			point = new Point(x, y);
		}
		
		public function distanceTo(x:Number, y:Number):Number 
		{
			return Math.sqrt((this.x - x) * (this.x - x) + (this.y - y) * (this.y - y));
		}
		
	}

}