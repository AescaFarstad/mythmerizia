package minigames.cardamon 
{
	import flash.geom.Point;
	

	public class CardamonHero extends CardamonActor 
	{
		private var space:CardamonSpace;
		public var x:Number;
		public var y:Number;
		public var size:Number;
		
		public var speed:Number = 0.01;
		
		public var vel:Point = new Point();
		public var dumping:Number = 0.90;
		public var turnability:Number = 0.002;
		
		
		public function CardamonHero() 
		{
			super();
		}
		
		public function load(space:CardamonSpace):void
		{
			this.space = space;
			vel = new Point(0.01, 0);
		}
		/*
		public function move(direction:Point, timePassed:int, space:CardamonSpace):void 
		{
			var vel:Number = direction.x && direction.y ? Math.SQRT2 : 1;
			vel *= timePassed;
			vel *= 0.01;
			
			var targetX:Number = x + vel * direction.x;
			var targetY:Number = y + vel * direction.y;
			
			if (!space.getCell(int(targetX), int(targetY)).isObstacle)
			{
				x = targetX;
				y = targetY;
			}
		}*/
		
		public function accel(point:Point, timePassed:int, space:CardamonSpace):void
		{
			var absVel:Number = Math.sqrt(vel.x * vel.x + vel.y * vel.y);
			vel.x += point.x * timePassed / 250 * Math.abs(vel.x) / absVel;
			vel.y += point.x * timePassed / 250 * Math.abs(vel.y) / absVel;
			
			var newVel:Point = new Point();
			var angle:Number = Math.atan2(vel.y, vel.x);
			var turnAngle:Number = turnability * timePassed * point.y;
			newVel.x = vel.x * Math.cos(turnAngle) - vel.y * Math.sin(turnAngle);
			newVel.y = vel.x * Math.sin(turnAngle) + vel.y * Math.cos(turnAngle);
			vel = newVel;
			
			trace("turnAngle", turnAngle, "angle", angle, "->", Math.atan2(vel.y, vel.x));
	
		}
		
		override public function update(timePassed:int):void
		{			
			var targetX:Number = x + vel.x;
			var targetY:Number = y + vel.y;
			
			if (!space.getCell(int(targetX), int(targetY)).isObstacle)
			{
				x = targetX;
				y = targetY;
			}
			
			trace("vel:", vel.length);
			
			var scale:Number = dumping;// Math.pow(dumping, timePassed);
			vel.x *= scale;
			vel.y *= scale;
		}
		
		
		
	}

}