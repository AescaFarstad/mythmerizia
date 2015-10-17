package minigames.navgraph 
{
	

	public class CellData 
	{
		public var x:int;
		public var y:int;
		public var isObstacle:Boolean;
		private var _mesh:Mesh;
		public var nearestNodes:Vector.<NavNode> = new Vector.<NavNode>();
		public var nearestPathElements:Vector.<Vector.<PathElement>> = new Vector.<Vector.<PathElement>>();
		public var meshes:Vector.<Mesh> = new Vector.<Mesh>();
		public var node:NavNode;
		
		public function CellData() 
		{
			
		}
		
		public function toString():String 
		{
			return ["[", x, ",", y, "]"].join("");
		}
		
		public function get mesh():Mesh 
		{
			return _mesh;
		}
		
		public function set mesh(value:Mesh):void 
		{
			_mesh = value;
			if (value)
			{
				meshes.push(value);
				if (meshes.length > 1)
					throw new Error();				
			}
		}
		
	}

}