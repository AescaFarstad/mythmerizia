package util 
{
	
	public class RMath 
	{
		
		public static function getItem(vec:*):*
		{
			return vec[int(vec.length * Math.random())];
		}
		
		public static function getWeightedItem(array:Array):*
		{
			var totalWeight:int = 0;
			for (var i:int = 0; i < array.length; i++) 
			{
				totalWeight += array[i].weight;
			}
			var point:int = Math.random() * totalWeight;
			for (i = 0; i < array.length; i++) 
			{
				point -= array[i].weight;
				if (point < 0)
					return array[i].value;
			}
			return null;
		}
		
	}

}