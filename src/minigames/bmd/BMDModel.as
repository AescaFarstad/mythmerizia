package minigames.bmd 
{
	import flash.geom.Point;
	public class BMDModel
	{
		public var sizeX:int = 50;
		public var sizeY:int = 40;
		public var cells:Vector.<Vector.<BMDCell>>;
		public var actors:Vector.<Actor>;
		
		public function BMDModel()
		{
			
		}
		
		public function init():void
		{
			initCells();
			initObstacles();
			initActors();
		}
		
		private function initBuildings():void
		{
			
		}
		
		private function initActors():void
		{
			actors = new Vector.<Actor>();
			
			for (var i:int = 0; i < 5; i++)
			{
				var point:Point = new Point();
				while (cells[int(point.x)][int(point.y)].isObstacle)
					point.setTo(Math.random() * sizeX, Math.random() * sizeY);
				var angle:Number = Math.random() * Math.PI * 2;
				var velocity:Point = new Point(5 * Math.cos(angle) / 1000, 5 * Math.sin(angle) / 1000);
				spawnBall(point, velocity);
			}
			
			for (i = 0; i < 5; i++)
			{
				var shooter:ShooterBuilding = new ShooterBuilding();
				point = new Point();
				while (true)
				{					
					point.setTo(Math.random() * sizeX, Math.random() * sizeY);
					var cell:BMDCell = cells[int(point.x)][int(point.y)];
					if (cell.isObstacle && cell.buildings.length == 0 && !cell.isBorder)
						break;
				}
				
				shooter.x = int(point.x);
				shooter.y = int(point.y);
				cell.buildings.push(shooter);
				addActor(shooter);				
			}
		}
		
		private function addActor(actor:Actor):void
		{			
			actors.push(actor);
			actor.load(this);
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < actors.length; i++)
			{
				actors[i].think(timePassed);
			}
		}
		
		public function spawnBall(location:Point, velocity:Point):void
		{
			var ball:Ball = new Ball();
			ball.x = location.x;
			ball.y = location.y;
			ball.size = 0.3;
			ball.velocity = velocity;
			addActor(ball);
		}
		
		public function trigger(x:int, y:int):void
		{
			var actorsToKill:Vector.<Actor> = new Vector.<Actor>();
			if (cells[x][y].buildings.length == 0 && cells[x][y].isObstacle && !cells[x][y].isBorder)
			{
				for (var i:int = 0; i < actors.length; i++)
				{
					if (actors[i] is Ball)
					{
						if (actors[i].x > x - 1 && actors[i].x < x + 1 && 
							actors[i].y > y - 1 && actors[i].y < y + 1)
						{
							actorsToKill.push(actors[i]);
						}
					}
				}
			}
			for (var j:int = 0; j < actorsToKill.length; j++)
			{
				killActor(actorsToKill[j]);
			}			
		}
		
		private function killActor(actor:Actor):void
		{
			actors.splice(actors.indexOf(actor), 1);
			if (actor is ShooterBuilding)
				cells[actor.x][actor.y].buildings.splice(cells[actor.x][actor.y].buildings.indexOf(actor), 1);
		}
		
		private function initObstacles():void
		{
			for (var i:int = 0; i < sizeX; i++)
			{
				cells[i][0].isObstacle = true;
				cells[i][0].isBorder = true;
				cells[i][sizeY - 1].isObstacle = true;
				cells[i][sizeY - 1].isBorder = true;
			}
			for (i = 0; i < sizeY; i++)
			{
				cells[0][i].isObstacle = true;
				cells[0][i].isBorder = true;
				cells[sizeX - 1][i].isObstacle = true;
				cells[sizeX - 1][i].isBorder = true;
			}
			var numObstacles:int = 50;
			for (var j:int = 0; j < numObstacles; j++)
			{
				cells[int(sizeX * Math.random())][int(sizeY * Math.random())].isObstacle = true;
			}
		}
		
		private function initCells():void
		{
			cells = new Vector.<Vector.<BMDCell>>();
			for (var i:int = 0; i < sizeX; i++)
			{
				var vec:Vector.<BMDCell> = new Vector.<BMDCell>();
				for (var j:int = 0; j < sizeY; j++)
				{
					var cell:BMDCell = new BMDCell();
					cell.x = i;
					cell.y = j;
					vec.push(cell);
				}
				cells.push(vec);
			}			
		}
		
	}
}