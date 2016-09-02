package minigames.trader 
{
	public class Resource
	{
		public var name:String;
		public var value:int;
		public var cap:int;
		public var baseValue:Number;
		public var progression:ResourceProgression;
		
		public function Resource()
		{
			
		}
		
		public function get currentValue():Number
		{
			return baseValue * progression.multi;
		}
		
	}
}