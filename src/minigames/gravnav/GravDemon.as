package minigames.gravnav 
{
	import flash.geom.Point;
	
	public class GravDemon 
	{
		private static const DIRECTIONS:Vector.<Point> = new <Point>[new Point(0, -1), new Point(1, 0), new Point(0, 1), new Point(-1, 0)];
		
		public var x:Number;
		public var y:Number;
		
		public var listener:IHeroListener;
		
		public function GravDemon() 
		{
			
		}
		
		public function move(gravnavModel:GravnavModel):int 
		{
			var length:int = 0;
			if (Math.random() > 0.85)
				length = moveRandom(gravnavModel);
			else
				length = moveToHero(gravnavModel);
			return length;
		}
		
		private function moveToHero(gravnavModel:GravnavModel):int 
		{
			var direction:Point = gravnavModel.getFirstStep(x, y, gravnavModel.hero.x, gravnavModel.hero.y);
			if (direction)
			{
				return travel(direction, gravnavModel);
			}
			else
				return moveRandom(gravnavModel);
		}
		
		private function moveRandom(gravnavModel:GravnavModel):int 
		{
			var option:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < DIRECTIONS.length; i++) 
			{
				if (gravnavModel.cells[y + DIRECTIONS[i].y][x + DIRECTIONS[i].x])
					option.push(DIRECTIONS[i]);
			}
			if (option.length > 0)
				return travel(option[int(Math.random() * option.length)], gravnavModel);
			return 0;
		
		}
		
		public function travel(target:Point, model:GravnavModel):int 
		{	
			var length:int = 0;
			
			while (model.cells[y + target.y][x + target.x])
			{
				length++;
				x += target.x;
				y += target.y;				
			}
			if (listener)
				listener.onTravel(length);
			return length;
		}
	}

}