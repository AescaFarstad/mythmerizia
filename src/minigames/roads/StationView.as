package minigames.roads 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class StationView extends Sprite
	{
		public var station:Station;
		private var scale:Number;
		private var label:Sprite;
		public var model:RoadsModel;
		
		public function StationView()
		{
			super();
			scale = RoadsView.scale;
			
			label = new Sprite();
			addChild(label);
		}
		
		public function load(station:Station, model:RoadsModel):void
		{
			this.model = model;
			this.station = station;
			
			graphics.beginFill(0, 0);
			graphics.drawRect(station.p1.x * scale, station.p1.y * scale - scale / 6, scale, scale / 3);
			graphics.endFill();
			
			addEventListener(MouseEvent.CLICK, onClick);
			
			label.graphics.lineStyle(2, 0x0000ff);
			
			label.x = (station.p1.x + station.p2.x) * scale / 2;
			label.y = station.p1.y * scale;
			if (station.stage == 0)
				return;
			switch(station.index % 4)
			{
				case 0:
					{
						label.graphics.beginFill(0, 0);
						label.graphics.drawCircle(0, 0, 10);
						label.graphics.endFill();
						break;
					}
				case 1:
					{
						label.graphics.beginFill(0, 0);
						label.graphics.drawRect(-5, -5, 10, 10);
						label.graphics.endFill();
						break;
					}
				case 2:
					{
						label.graphics.beginFill(0, 0);
						CarView.drawPolygon(label.graphics, 10, 4);
						label.graphics.endFill();
						break;
					}
				case 3:
					{
						label.graphics.beginFill(0, 0);
						CarView.drawPolygon(label.graphics, 10, 5);
						label.graphics.endFill();
						break;
					}
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			model.sendCar(station);
		}
		
	}
}