package minigames.labris 
{
	public class LabrisModel 
	{
		public const SIZE_X:int = 125;
		public const SIZE_Y:int = 100;		
		
		public var cells:Vector.<Vector.<LabrisCell>>;	
		
		public var isChanged:Boolean;
		private var time:int;
		private var cooldown:int;
		private var maxCooldown:int = 400;
		
		public function LabrisModel() 
		{
			cells = new Vector.<Vector.<LabrisCell>>();
			
			for (var i:int = 0; i < SIZE_X; i++) 
			{
				var vec:Vector.<LabrisCell> = new Vector.<LabrisCell>();
				for (var j:int = 0; j < SIZE_Y; j++) 
				{
					vec.push(new LabrisCell(i, j, i == 0 || j == 0 || i == SIZE_X - 1 || j == SIZE_Y -1 || Math.random() > 0.90));
				}
				cells.push(vec);
			}
			cooldown = 1000;
		}
		
		public function update(timePassed:int):void 
		{
			time+= timePassed;
			cooldown -= timePassed;
			isChanged = false;
			if (cooldown <= 0)
			{
				isChanged = true;
				evolve(5);
				if (!isChanged)
				{					
					cooldown = 40000000000;
					trace("it's over");
					evolve(5);
					isChanged = true;
				}
				else
					cooldown = maxCooldown;
			}
		}
		
		private function evolve(count:int):void 
		{
			maxCooldown-=10;
			for (var i:int = 0; i < cells.length; i++) 
			{
				for (var j:int = 0; j < cells[i].length; j++) 
				{
					if (i == 0 || j == 0 || i == SIZE_X - 1 || j == SIZE_Y -1)
						continue;
					var liveCount:int = 0;
					if (!cells[i-1][j].isObstacle) liveCount++;
					if (!cells[i-1][j-1].isObstacle) liveCount++;
					if (!cells[i-1][j+1].isObstacle) liveCount++;
					if (!cells[i][j-1].isObstacle) liveCount++;
					if (!cells[i][j+1].isObstacle) liveCount++;
					if (!cells[i+1][j].isObstacle) liveCount++;
					if (!cells[i+1][j-1].isObstacle) liveCount++;
					if (!cells[i + 1][j + 1].isObstacle) liveCount++;
					if (liveCount == 3)
						cells[i][j].newIsObstacle = false;
					else if (liveCount > count)
						cells[i][j].newIsObstacle = true;
					else
						cells[i][j].newIsObstacle = cells[i][j].isObstacle;
					cells[i][j].isObstacle = cells[i][j].newIsObstacle;
				}
			}
			
			for (i = 0; i < cells.length; i++) 
			{
				for (j = 0; j < cells[i].length; j++) 
				{
					if (i == 0 || j == 0 || i == SIZE_X - 1 || j == SIZE_Y -1)
						continue;
					if (isChanged || cells[i][j].isObstacle != cells[i][j].newIsObstacle)
						isChanged = true;
					cells[i][j].isObstacle = cells[i][j].newIsObstacle;
				}
			}
		}
		
	}

}