package minigames.navgraph 
{
	import flash.geom.Point;
	
	public class NavNode 
	{
		public var cell:CellData;
		public var links:Vector.<NavNode>;
		public var distances:Vector.<Number>;
		public var frontier:Vector.<CellData>;
		public var debugColor:uint;
		public var point:Point;
		
		public function NavNode(cell:CellData) 
		{
			this.cell = cell;
			debugColor = Math.random() * 0xffffff;
			if (cell)
				point = new Point(cell.x + 0.5, cell.y + 0.5);
			distances = new Vector.<Number>();
			links = new Vector.<NavNode>();
		}
		
		public function addLink(node:NavNode):void
		{
			links.push(node);
			distances.push(Math.sqrt(Math.pow(node.cell.x - cell.x, 2) + Math.pow(node.cell.y - cell.y, 2)));
		}
		
		public function get x():Number
		{
			return point.x;
		}
		
		public function get y():Number
		{
			return point.y;
		}
		
	}

}