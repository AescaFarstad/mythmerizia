package minigames.gravnav 
{
	import flash.geom.Point;
	
	public class GravnavModel 
	{
		
		public static const SIZE_X:int = 25;
		public static const SIZE_Y:int = 25;
		
		public var cells:Vector.<Vector.<Boolean>>;
		public var hero:Hero;
		
		public function GravnavModel() 
		{
			restart();
		}
		
		public function restart():void 
		{
			cells = new Vector.<Vector.<Boolean>>();
			for (var i:int = 0; i < SIZE_Y; i++) 
			{
				cells.push(new Vector.<Boolean>());
				for (var j:int = 0; j < SIZE_X; j++) 
				{
					cells[i].push(i != 0 && i != SIZE_Y - 1 && j != 0 && j != SIZE_Y -1);
				}
			}
			
			var numObstacles:int = 45;
			for (var l:int = 0; l < numObstacles; l++) 
			{
				var cell:Point = null;
				while (!cell || !cells[cell.y][cell.x])
					cell = new Point(int(Math.random() * SIZE_X), int(Math.random() * SIZE_Y));
				cells[cell.y][cell.x] = false;
				
			}
			
			hero = new Hero();
			cell = null;
			while (!cell || !cells[cell.y][cell.x])
				cell = new Point(int(Math.random() * SIZE_X), int(Math.random() * SIZE_Y));
			hero.x = cell.x;
			hero.y = cell.y;
		}
		
		public function update(timePassed:int):void 
		{
			
		}
	}

}