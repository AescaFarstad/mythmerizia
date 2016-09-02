package minigames.trader 
{
	public class ResourcePack
	{
		public var resource:Resource;
		public var amount:int;
		
		public function ResourcePack()
		{
			
		}
		
		public function take():void
		{
			resource.value -= amount;
		}
		
		public function give():void
		{
			resource.value += amount;
		}
		
	}
}