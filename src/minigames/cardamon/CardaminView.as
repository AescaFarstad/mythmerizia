package minigames.cardamon 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import minigames.cardamon.CellData;
	
	

	public class CardaminView extends Sprite 
	{
		private static const SCALE:Number = 20;
		private static const SIZE_X:Number = 1000;
		private static const SIZE_Y:Number = 800;
		
		
		
		private var space:CardamonSpace;
		private var viewport:Rectangle;
		
		public function CardaminView() 
		{
			super();
			
		}
		
		public function load(space:CardamonSpace):void 
		{
			this.space = space;
			viewport = new Rectangle(0, 0, SIZE_X / SCALE, SIZE_Y / SCALE);
			render();
		}
		
		private function render():void 
		{
			graphics.clear();
			for (var i:int = 0; i < space.submatrix.length; i++) 
			{
				if (space.submatrix[i])
				{
					for (var j:int = 0; j < space.submatrix[i].length; j++) 
					{
						var subMatrix:Vector.<Vector.<CellData>> = space.submatrix[i][j] ? space.submatrix[i][j].matrix : null;
						if (subMatrix)
						{
							for (var k:int = 0; k < subMatrix.length; k++) 
							{
								for (var l:int = 0; l < subMatrix[k].length; l++) 
								{
									if (subMatrix[k][l].isObstacle)
									{
										graphics.beginFill(0x0, 0.3);
										var startX:Number = (space.submatrix[i][j].x * SubSpace.SIZE + l - viewport.x) * SCALE;
										var startY:Number = (space.submatrix[i][j].y * SubSpace.SIZE + k - viewport.y) * SCALE;
										graphics.drawRect(startX, startY, SCALE, SCALE);
										
										graphics.endFill();
									}
								}
							}
						}
					}					
				}
			}
			
			graphics.beginFill(0x0000ff, 1);
			graphics.drawCircle((space.hero.x - viewport.x) * SCALE, (space.hero.y - viewport.y) * SCALE, 5);
			graphics.endFill();
		}
		
		public function update(timePassed:int):void
		{
			//viewport.x += timePassed/100;
			viewport.x = space.hero.x -  SIZE_X / 2 / SCALE;
			viewport.y = space.hero.y -  SIZE_Y / 2 / SCALE;
			render();
		}
		
	}

}