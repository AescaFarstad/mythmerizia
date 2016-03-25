package minigames.clik_or_crit.lib 
{
	import flash.utils.ByteArray;
	
	public class CCLibrary 
	{
		static public var countries:CountryLib;
		static public var settings:SettingsLib;
		
		static public function init():void
		{
			countries = new CountryLib(resToSource(S.resources.bin.countries));
			settings = new SettingsLib(resToSource(S.resources.bin.settings));
		}
		
		static private function resToSource(res:ByteArray):Object
		{
			return JSON.parse(res.readUTFBytes(res.length));
		}
	}

}