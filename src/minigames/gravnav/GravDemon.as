package minigames.gravnav 
{
	import flash.geom.Point;
	
	public class GravDemon 
	{
		public static const TYPE_DIRECT:int = 0;
		public static const TYPE_AHEAD:int = 1;
		
		private static const DIRECTIONS:Vector.<Point> = new <Point>[new Point(0, -1), new Point(1, 0), new Point(0, 1), new Point(-1, 0)];
		
		public var x:Number;
		public var y:Number;
		
		public var listener:IHeroListener;
		public var type:int;
		public var lastFuturePoint:FuturePoint;
		
		public function GravDemon() 
		{
			type = Math.random() * 2;
			//type = TYPE_AHEAD;
		}
		
		public function move(gravnavModel:GravnavModel):int 
		{
			/*return moveToCover(gravnavModel);*/
			
			var myOptions:Vector.<Point> = gravnavModel.getMoveOptions(gravnavModel.hero.x, gravnavModel.hero.y);
			myOptions.push(new Point(x, y));
			for (var i:int = 0; i < myOptions.length; i++)
			{
				if (myOptions[i].x == gravnavModel.hero.x && myOptions[i].y == gravnavModel.hero.y)
					return moveToPoint(myOptions[i], gravnavModel);
			}
			
			var length:int = 0;
			if (Math.random() > 0.75)
				length = moveRandom(gravnavModel);
			else if (type == TYPE_DIRECT)
				length = moveToHero(gravnavModel);
			else
				length = moveAhead(gravnavModel);
			return length;
		}
		
		private function moveToCover(model:GravnavModel):int 
		{
			if (lastFuturePoint)
			{
				for (var k:int = 0; k < model.futurePoints.length; k++) 
				{
					if (model.futurePoints[k].x == lastFuturePoint.x && 
						model.futurePoints[k].y == lastFuturePoint.y)
					{
						model.futurePoints[k].isCovered = true;
						return moveToPoint(new Point(lastFuturePoint.x, lastFuturePoint.y), model);
					}
				}
			}
			
			var futurePoints:Vector.<FuturePoint> = model.updateFuturePoints(x, y);
			for (var i:int = 0; i < model.futurePoints.length; i++) 
			{
				for (var j:int = 0; j < futurePoints.length; j++) 
				{
					if (futurePoints[j].delay <= model.futurePoints[i].delay && 
						!model.futurePoints[i].isCovered && 
						futurePoints[j].x == model.futurePoints[i].x &&
						futurePoints[j].y == model.futurePoints[i].y)
						lastFuturePoint = futurePoints[j];
						return moveToPoint(new Point(futurePoints[j].x, futurePoints[j].y), model);
				}
			}
			return moveToHero(model);
		}
		
		private function moveAhead(gravnavModel:GravnavModel):int
		{			
			var heroOptions:Vector.<Point> = gravnavModel.getMoveOptions(gravnavModel.hero.x, gravnavModel.hero.y);
			if (heroOptions.length > 0)
			{
				var option:Point = heroOptions[int(Math.random() * heroOptions.length)];
				return moveToPoint(option, gravnavModel);
			}
			else
			{
				return moveRandom(gravnavModel);
			}
		}
		
		private function moveToPoint(point:Point, gravnavModel:GravnavModel):int
		{
			var direction:Point = gravnavModel.getFirstStep(x, y, point.x, point.y);
			if (direction)
			{
				return travel(direction, gravnavModel);
			}
			else
				return moveRandom(gravnavModel);
		}
		
		private function moveToHero(gravnavModel:GravnavModel):int 
		{
			return moveToPoint(new Point(gravnavModel.hero.x, gravnavModel.hero.y), gravnavModel);			
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