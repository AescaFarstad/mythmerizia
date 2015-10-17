package minigames.cardamon 
{
	import flash.geom.Point;
	

	public class CardamonSpace 
	{
		public var submatrix:Vector.<Vector.<SubSpace>>;
		public var actors:Vector.<CardamonActor>; 
		public var hero:CardamonHero;
		
		public function CardamonSpace() 
		{
			submatrix = new Vector.<Vector.<SubSpace>>();
			var row:Vector.<SubSpace> = new Vector.<SubSpace>();
			var sub:SubSpace = new SubSpace(0, 0);
			row.push(sub);
			submatrix.push(row);
			
			actors = new Vector.<CardamonActor>();
			
			hero = new CardamonHero();
			hero.x = 10.5;
			hero.y = 11.4;
			hero.size = 0.2;
			hero.load(this);
			actors.push(hero);
			submatrix[0][0].matrix[11][10].isObstacle = false;
			submatrix[0][0].matrix[10][10].isObstacle = false;
			submatrix[0][0].matrix[11][9].isObstacle = false;
			submatrix[0][0].matrix[11][11].isObstacle = false;
			submatrix[0][0].matrix[12][10].isObstacle = false;
		}
		
		public function getCell(targetX:int, targetY:int):CellData 
		{
			return submatrix[0][0].matrix[targetY][targetX];
		}
		
		public function DDAVisible(p1:*, p2:Point):Boolean
		{
			var dx:Number = Math.abs(p2.x - p1.x);
			var dy:Number = Math.abs(p2.y - p1.y);
			var xStep:Number = (p1.x < p2.x ? +1 : -1);
			var yStep:Number = (p1.y < p2.y ? +1 : -1);
			var lastCellX:int = p1.x;
			var lastCellY:int = p1.y;
			
			if (dx > dy)
			{
				var shift:int = (xStep > 0 ? 1 : 0);
				var iter:int = lastCellX + shift;
				var slope:Number = (p2.y - p1.y) / (p2.x - p1.x);
				var elevation:Number = p1.y - p1.x * slope;
				var numChecks:int = Math.abs(int(p1.x) - int(p2.x));
				for (var i:int = 0; i <= numChecks; i++) 
				{
					var thisY:int = slope * iter + elevation;
					if (i < numChecks)
					{
						if (getCell(thisY, iter - shift).isObstacle)
							return true;
					}					
					if (lastCellY != thisY)
					{
						if (getCell(lastCellY, iter - shift).isObstacle)
							return true;
						lastCellY = thisY;
					}
					iter += xStep;
				}
			}
			else
			{
				shift = (yStep > 0 ? 1 : 0);
				iter = lastCellY + shift;
				slope = (p2.x - p1.x) / (p2.y - p1.y);
				elevation = p1.x - p1.y * slope;
				numChecks = Math.abs(int(p1.y) - int(p2.y));
				for (i = 0; i <= numChecks; i++) 
				{
					var thisX:int = slope * iter + elevation;
					if (i < numChecks)
					{
						if (getCell(iter - shift, thisX).isObstacle)
							return true;
					}					
					if (lastCellX != thisX)
					{
						if (getCell(iter - shift, lastCellX).isObstacle)
							return true;
						lastCellX = thisX;
					}	
					iter += yStep;
				}
			}
			return false;
		}
		
		//add spaces
		//move to the side even if forward is blocked
		//move forward always
		//don't tunnel through corners
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < actors.length; i++) 
			{
				actors[i].update(timePassed);
			}
		}
		
	}

}