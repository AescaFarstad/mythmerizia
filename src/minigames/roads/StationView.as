package minigames.roads 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class StationView extends Sprite
	{
		public var station:StationView;
		private var scale:Number;
		public var model:RoadsModel;
		
		public function StationView()
		{
			super();
			scale = RoadsView.scale;
		}
		
		public function load(station:StationView, model:RoadsModel):void
		{
			this.model = model;
			this.station = station;
			
			graphics.beginFill(0, 0);
			graphics.drawRect(model.stations[i].p1.x * scale, model.stations[i].p1.y * scale - scale / 6, scale, scale / 3);
			graphics.endFill();
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			model.sendCar(station);
		}
		
	}
}