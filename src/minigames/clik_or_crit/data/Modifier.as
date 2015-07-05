package minigames.clik_or_crit.data 
{
	

	public class Modifier 
	{
		public var multi:Number;
		public var add:Number;
		public var name:String;
		
		public function Modifier(name:String, add:Number = 0, multi:Number = 0) 
		{
			this.multi = multi;
			this.add = add;
			this.name = name;
			
		}
		
	}

}