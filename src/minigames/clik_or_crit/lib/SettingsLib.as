package minigames.clik_or_crit.lib 
{
	import util.Parse;
	
	public class SettingsLib 
	{
		
		public function SettingsLib(source:Object) 
		{
			Parse.parse(source, this);
		}
		
	}

}