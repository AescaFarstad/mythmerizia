package minigames.tsp 
{
	import flash.utils.ByteArray;
	
	public class TSPPlayerData 
	{
		private var rawData:Object;
		public var data:Vector.<LevelData> = new Vector.<LevelData>();
		
		
		public function TSPPlayerData() 
		{
			rawData = JSON.parse((S.resources.bin.TSPLevels as ByteArray).toString());
			for (var i:int = 0; i < rawData.levels.length; i++) 
			{
				var levelData:LevelData = new LevelData();
				levelData.score = 0;
				levelData.order = rawData.levels[i].order;
				levelData.points = rawData.levels[i].points;
				levelData.poissonFactor = rawData.levels[i].poissonFactor;
				levelData.discoveredAt = rawData.levels[i].discoveredAt;
				levelData.requires = rawData.levels[i].requires;
				levelData.name = rawData.levels[i].name;
				data.push(levelData);
			}
			data.sort(sortOnOrder);
		}
		
		private function sortOnOrder(a:LevelData, b:LevelData):int 
		{
			if (a.order == b.order)
				return 0;
			return a.order > b.order ? 1 : -1;
		}
		
		public function toString():String		
		{
			var res:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < data.length; i++) 
			{
				res.push(data[i].score);
			}
			return res.join(",");
		}
		
		public function fromString(str:String):void
		{
			if (!str)
				return;
			var parts:Array = str.split(",");
			for (var i:int = 0; i < parts.length && i < data.length; i++) 
			{
				data[i].score = Math.max(Math.min(3, Number(parts[i])), 0);
			}
		}
		
		public function get totalStars():int
		{
			var count:int = 0;
			for (var i:int = 0; i < data.length; i++) 
			{
				count += data[i].score;
			}
			return count;
		}
		
	}

}