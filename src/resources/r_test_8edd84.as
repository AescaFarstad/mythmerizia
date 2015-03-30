package resources
{	
	public class r_test_8edd84 extends Folder
	{
		public function r_test_8edd84() 
		{
			 
		}
			
		/**
		* 0: temporary text
		*
		*/
		public function testText():String
		{
			var locale:int = __settings.localeIndex;
			switch(locale)
			{
				case 0:
					return "temporary text";
			}
			return "Resource not found";
		}
		
	}
}
