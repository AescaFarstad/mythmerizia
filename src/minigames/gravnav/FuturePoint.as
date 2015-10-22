package minigames.gravnav 
{
	
	public class FuturePoint 
	{
		public var x:int;
		public var y:int;
		public var delay:int;
		public var isCovered:Boolean;
		
		
		public function FuturePoint() 
		{
			
		}
		
		static public function sort(a:FuturePoint, b:FuturePoint):int 
		{
			if (a.delay == b.delay)
				return 0;
			return a < b ? 1 : -1;
		}
		
	}

}