package resources
{	
	public class r_format_1f8ba2 extends Folder
	{
		public function r_format_1f8ba2() 
		{
			 
		}
			
		/**
		* 0: &lt;#main#{$fontSize}#:
		*
		*/
		public function main(fontSize_Var:Object):String
		{
			var locale:int = __settings.localeIndex;
			switch(locale)
			{
				case 0:
					return "<#main#" + fontSize_Var.toString() + "#:";
			}
			return "Resource not found";
		}
		
		/**
		* 0: &lt;#edge#{$fontSize}#:
		*
		*/
		public function edge(fontSize_Var:Object):String
		{
			var locale:int = __settings.localeIndex;
			switch(locale)
			{
				case 0:
					return "<#edge#" + fontSize_Var.toString() + "#:";
			}
			return "Resource not found";
		}
		
	}
}
