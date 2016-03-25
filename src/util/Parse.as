package util 
{
	
	public class Parse 
	{
		
		static public function parse(source:Object, target:*):*
		{
			for (var key:String in source)
				target[key] = source[key];
			return target;
		}
		
	}

}