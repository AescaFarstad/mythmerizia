package minigames.roads 
{
	import flash.display.Sprite;
	
	public class RoadsView extends Sprite
	{
		public var model:RoadsModel;
		static public var scale:Number = 100;
		
		public var stationViews:Vector.<StationView> = new Vector.<StationView>();
		
		public function RoadsView()
		{
			super();
			
		}
		
		public function load(model:RoadsModel):void
		{
			this.model = model;
			
			for (var i:int = 0; i < model.stations.length; i++)
			{
				var view:StationView = new StationView();
				view.load(model.stations[i], model);
				addChild(view);
				stationViews.push(view);
			}
			
		}
		
		public function update(timePassed:int):void
		{
			graphics.clear();
			
			drawPoints();
			drawRoads();
			drawStations();
		}
		
		private function drawStations():void
		{
			graphics.lineStyle(4, 0x009900);
			for (var i:int = 0; i < model.stations.length; i++)
			{
				graphics.beginFill(
				graphics.drawRect(model.stations[i].p1.x * scale, model.stations[i].p1.y * scale - scale / 6, scale, scale / 3);
			}
		}
		
		private function drawRoads():void
		{
			graphics.lineStyle(2, 0);
			for (var i:int = 0; i < model.roads.length; i++)
			{
				graphics.moveTo(model.roads[i].p1.x * scale, model.roads[i].p1.y * scale);
				graphics.lineTo(model.roads[i].p2.x * scale, model.roads[i].p2.y * scale);
			}
		}
		
		private function drawPoints():void
		{
			graphics.lineStyle(4, 0);
			for (var i:int = 0; i < model.points.length; i++)
			{
				graphics.drawCircle(model.points[i].x * scale, model.points[i].y * scale, 4);
			}
		}
		
	}
}