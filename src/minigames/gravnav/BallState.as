package minigames.gravnav 
{
	import flash.geom.Point;
	
	public class BallState 
	{
		
		public var balls:Vector.<Point>;
		public var turnCount:int;
		public var numBalls:int;
		public var history:BallState;
		public var lastMove:Point;
		
		public function applyDirection(direction:Point, model:GravnavModel):BallState
		{
			var newState:BallState = new BallState();
			newState.turnCount = turnCount + 1;
			newState.history = this;
			newState.balls = new Vector.<Point>();
			
			for (var i:int = 0; i < balls.length; i++) 
			{
				var newBall:Point = balls[i].clone();
				while (model.cells[newBall.y + direction.y][newBall.x + direction.x])
				{
					newBall.x += direction.x;
					newBall.y += direction.y;				
				}
				var hasDuplicate:Boolean = false;
				for (var j:int = 0; j < newState.balls.length; j++) 
				{
					if (newState.balls[j].x == newBall.x && newState.balls[j].y == newBall.y)
					{
						hasDuplicate = true;
						break;
					}
				}
				if (!hasDuplicate)
					newState.balls.push(newBall);
			}
			newState.numBalls = newState.balls.length;
			newState.lastMove = direction;
			return newState;
		}
		
	}

}