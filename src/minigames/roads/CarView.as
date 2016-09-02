package minigames.roads 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class CarView extends Sprite
	{
		private var model:RoadsModel;
		public var car:Car;
		
		public function CarView()
		{
			super();
			
		}
		
		public function load(car:Car, model:RoadsModel):void
		{
			this.model = model;
			this.car = car;
			
			graphics.lineStyle(2, 0x0000ff);
			
			switch(car.target.index % 4)
			{
				case 0:
					{
						graphics.beginFill(0, 0);
						graphics.drawCircle(0, 0, 10);
						graphics.endFill();
						break;
					}
				case 1:
					{
						graphics.beginFill(0, 0);
						graphics.drawRect(-5, -5, 10, 10);
						graphics.endFill();
						break;
					}
				case 2:
					{
						graphics.beginFill(0, 0);
						drawPolygon(graphics, 10, 4);
						graphics.endFill();
						break;
					}
				case 3:
					{
						graphics.beginFill(0, 0);
						drawPolygon(graphics, 10, 5);
						graphics.endFill();
						break;
					}
			}
		}
		
		static public function drawPolygon(target:Graphics, size:int, numVert:int):void
		{			
			for (var i:int = 0; i < numVert+1; i++)
			{
				var point:Point = pointByIndex(i % numVert, numVert, size);
				target.moveTo(point.x, point.y);
				point = pointByIndex((i + 1) % numVert, numVert, size);
				target.lineTo(point.x, point.y);
			}			
		}
		
		static public function pointByIndex(index:int, numVert:int, size:int):Point
		{
			var angle:Number = Math.PI * 2 * index / numVert;
			return new Point(size * Math.cos(angle), size * Math.sin(angle));
		}
		
	}
}