package minigames.roads 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	public class RoadsModel
	{
		[Embed(source = "data.json", mimeType = "application/octet-stream")]
		private var DATA:Class;
		
		private var MAX_X:int = 1000;
		
		public var points:Vector.<Point>;
		public var pointByHash:Dictionary;
		
		public var stations:Vector.<Station>;
		public var roads:Vector.<Road>;
		
		public function RoadsModel()
		{
			
		}
		
		public function init():void
		{
			var data:Object = JSON.parse(new DATA().toString());
			
			pointByHash = new Dictionary();
			points = new Vector.<Point>();
			
			stations = new Vector.<Station>();
			for (var i:int = 0; i < data.stations.length; i++)
			{
				stations.push(new Station(
						getPoint(data.stations[i].x, data.stations[i].y), 
						getPoint(data.stations[i].x + 1, data.stations[i].y), 
						data.stations[i].stage));
			}
			
			roads = new Vector.<Road>();
			for (i = 0; i < data.roads.length; i++)
			{
				roads.push(new Road(
						getPoint(data.roads[i].x1, data.roads[i].y1), 
						getPoint(data.roads[i].x2, data.roads[i].y2)));
			}
		}
		
		public function update(timePassed:int):void
		{
			
		}
		
		private function getPoint(x:Number, y:Number):Point
		{
			var hash:int = x + y * MAX_X;
			if (pointByHash[hash])			
				return pointByHash[hash];
			else
			{
				var p:Point = new Point(x, y);
				pointByHash[hash] = p;
				points.push(p);
				return p;
			}
		}
		
	}
}