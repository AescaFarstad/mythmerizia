package minigames.bmd 
{
	import flash.geom.Point;
	public class ShooterBuilding extends Actor
	{
		private const cooldown:int = 1000;
		
		private var cooldownLeft:int;
		private var cells:Vector.<BMDCell>;
		
		public function ShooterBuilding()
		{
			super();
		}
		
		override public function load(model:BMDModel):void 
		{
			super.load(model);
			cells = new Vector.<BMDCell>();
			cells.push(model.cells[x + 1][y]);
			cells.push(model.cells[x - 1][y]);
			cells.push(model.cells[x][y + 1]);
			cells.push(model.cells[x][y - 1]);
		}
		
		override public function think(timePassed:int):void 
		{
			if (cooldownLeft > 0)
				cooldownLeft -= timePassed;
			else
				shoot();
		}
		
		private function shoot():void
		{
			cooldownLeft = cooldown;
			var num:int = Math.random() * cells.length;
			var obstacleCount:int;
			while (num > 0 && obstacleCount < cells.length)
			{
				var index:int = (index + 1) % cells.length;
				if (!cells[index].isObstacle)
					num--;
				else
					obstacleCount++;
			}
			if (obstacleCount < cells.length)
			{
				var location:Point = new Point(cells[index].x + 0.5, cells[index].y + 0.5);
				var angle:Number = Math.atan2(location.y - y, location.x - x);
				var velocity:Point = new Point(5 * Math.cos(angle) / 1000, 5 * Math.sin(angle) / 1000);
				model.spawnBall(location, velocity);
			}
		}
		
	}
}