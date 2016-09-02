package minigames.trader 
{
	public class Offer
	{
		public var price:ResourcePack;
		public var result:Vector.<ResourcePack> = new Vector.<ResourcePack>();
		public var persona:Persona;
		public var daysLeft:int;
		public var onHold:Boolean;
		
		public function Offer()
		{
			
		}
		
		public function passDay():void
		{
			if (!onHold)
				daysLeft--;
		}
		
		public function isValid():Boolean
		{
			return price.amount <= price.resource.value;
		}
		
	}
}