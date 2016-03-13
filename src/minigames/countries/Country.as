package minigames.countries 
{
	public class Country
	{
		public var x:Number;
		public var y:Number;
		public var lat:Number;
		public var lon:Number;
		public var gdp:Number;
		public var area:Number;
		public var name:String;
		public var code:String;
		
		public var owned:Boolean;
		
		public function Country(name:String, x:Number, y:Number)
		{
			this.y = y;
			this.x = x;
			this.name = name;			
		}
		
	}
}