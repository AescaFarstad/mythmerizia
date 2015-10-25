package minigames.gravnav 
{
	import flash.geom.Point;
	
	public class GravBall 
	{
		public var x:Number;
		public var y:Number;
		
		public var listener:IHeroListener;
		
		public function GravBall() 
		{
			
		}
		
		public function travel(target:Point, model:GravnavModel):int 
		{	
			var length:int = 0;
			
			while (model.cells[y + target.y][x + target.x])
			{
				length++;
				x += target.x;
				y += target.y;				
			}
			if (listener)
				listener.onTravel(length);
			return length;
		}
		
	}

}