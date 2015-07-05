package minigames.navgraph 
{
	import flash.geom.Rectangle;
	
	

	public class Mesh extends Rectangle 
	{
		public var linkage:Vector.<Mesh> = new Vector.<Mesh>();
		
		
		public function Mesh(x:Number=0, y:Number=0, width:Number=0, height:Number=0) 
		{
			super(x, y, width, height);
			
		}
		/*
		public function contains(x:Number, y:Number):Boolean
		{
			return  x >= this.x && x < this.x + width &&
					y >= this.y && y < this.y + height;
		}
		*/
	}

}