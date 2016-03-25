package minigames.clik_or_crit.model 
{
	import minigames.clik_or_crit.lib.CountryItem;
	
	public class Country 
	{
	
		public var lib:CountryItem;
		public var discovered:Boolean;
		public var owned:Boolean;
		public var x:Number;
		public var y:Number;
		
		public function Country() 
		{
			
		}
		
		public function load(lib:CountryItem):void
		{
			this.lib = lib;
			x = lib.x;
			y = lib.y;
		}
		
		public function toString():String
		{
			return "[" + lib.name + " " + (x * 100).toFixed() + ":" + (y * 100).toFixed() + "]";
		}
		
		public function get asString():String
		{
			return toString();
		}
	}

}