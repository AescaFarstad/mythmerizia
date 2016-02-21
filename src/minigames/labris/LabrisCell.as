package minigames.labris 
{
	public class LabrisCell 
	{
		public var x:int;
		public var y:int;
		public var isObstacle:Boolean;
		public var newIsObstacle:Boolean;
		
		public function LabrisCell(x:int, y:int, isObstacle:Boolean) 
		{
			this.y = y;
			this.x = x;
			this.isObstacle = isObstacle;
			
		}
		
	}

}