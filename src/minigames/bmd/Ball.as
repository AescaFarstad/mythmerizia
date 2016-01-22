package minigames.bmd 
{
	import flash.geom.Point;
	import util.HMath;
	public class Ball extends Actor
	{
		public var size:Number;
		
		public var velocity:Point;
		
		public function Ball()
		{
			
		}
		
		override public function think(timePassed:int):void
		{
			var nextX:Number = x + velocity.x * timePassed;
			var nextY:Number = y + velocity.y * timePassed;
			
			if (model.cells[int(nextX)][int(nextY)].isObstacle)
			{
				velocity = HMath.rotateVector(velocity.x, velocity.y, Math.random() * Math.PI * 2);
			}
			else
			{
				x = nextX;
				y = nextY;
			}
			
		}
		
	}
}