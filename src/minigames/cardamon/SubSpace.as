package minigames.cardamon 
{
	import minigames.cardamon.CellData;
	public class SubSpace 
	{
		public static const SIZE:int = 100;
		public var y:int;
		public var x:int;
		
		public var matrix:Vector.<Vector.<CellData>>
		
		public function SubSpace(x:int, y:int) 
		{
			this.y = y;
			this.x = x;
			matrix = new Vector.<Vector.<CellData>>();
			
			for (var i:int = 0; i < SIZE; i++) 
			{
				var row:Vector.<CellData> = new Vector.<CellData>();
				
				for (var j:int = 0; j < SIZE; j++) 
				{
					var cell:CellData = new CellData();
					cell.isObstacle = Math.random() > 0.99 || i == 0 && Math.random() > 0.98;
					row.push(cell);
				}
				matrix.push(row);
			}
		}
	}
}