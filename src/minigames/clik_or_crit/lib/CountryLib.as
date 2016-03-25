package minigames.clik_or_crit.lib 
{
	import flash.utils.Dictionary;
	import util.HMath;
	import util.Parse;	
	
	public class CountryLib 
	{
		public var list:Vector.<CountryItem> = new Vector.<CountryItem>();
		public var dict:Dictionary = new Dictionary();
		
		public function CountryLib(source:Object) 
		{			
			var array:Array = source as Array;
			for (var i:int = 0; i < array.length; i++) 
			{
				var item:CountryItem = Parse.parse(array[i], new CountryItem());
				dict[item.id] = item;
				/*
				item.x = HMath.linearInterp(-180, 0, 180, 1, item.lon);
				item.y = HMath.linearInterp(90, 0, -90, 1, item.lat);
				/*
				var latRad:Number = item.lat * Math.PI / 180;
				item.y = Math.log(Math.tan(Math.PI / 4 + latRad / 2));
				item.y = item.y / (Math.PI);
				//item.y /= 5;_pixelOrigin.y + 0.5 * Math.log((1 + siny) / (1 - siny))*/
				
				
				
				var latitude:Number    = item.lat; // (φ)
				var longitude:Number   = item.lon;   // (λ)

				var mapWidth:Number    = 1;
				var mapHeight:Number   = 1;

				// get x value
				item.x = (longitude+180) * (mapWidth / 360);

				// convert from degrees to radians
				var latRad:Number = latitude*Math.PI/180;

				// get y value
				var mercN:Number = Math.log(Math.tan((Math.PI/4)+(latRad/2)));
				item.y = (mapHeight/2)-(mapWidth*mercN/(2*Math.PI));
				
				
				
				
				
				
				
				
				
				
				
				
				list.push(item);
			}
		}
		
		public function byID(id:int):CountryItem
		{
			return dict[id];
		}
	}

}