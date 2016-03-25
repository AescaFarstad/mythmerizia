package minigames.clik_or_crit.data 
{
	

	public class Resource 
	{
		public var name:String;
		public var value:Number;
		public var increase:Attribute;
		
		public function Resource(name:String, value:Number) 
		{
			this.value = value;
			this.name = name;
		}
		
		public function update(timePassed:int):void 
		{
			if (increase)
				value+= increase.value * timePassed;
		}
		
	}

}