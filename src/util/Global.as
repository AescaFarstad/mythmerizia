package util 
{
	

	public class Global 
	{
		private static var lastID:int;
		
		public static function get uniqueID():int
		{
			return lastID++;
		}
		
	}

}