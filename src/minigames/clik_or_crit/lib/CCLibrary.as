package minigames.clik_or_crit.lib 
{
	import flash.utils.ByteArray;
	
	public class CCLibrary 
	{
		static public var actions:ActionLibrary;
		static public var countries:CountryLib;
		static public var settings:SettingsLib;
		static public var buildings:BuildingLib;
		
		static public function init():void
		{
			actions = new ActionLibrary();
			countries = new CountryLib(resToSource(S.resources.bin.countries));
			settings = new SettingsLib(resToSource(S.resources.bin.settings));
			buildings = new BuildingLib(resToSource(S.resources.bin.buildings));
		}
		
		static private function resToSource(res:ByteArray):Object
		{
			return JSON.parse(res.readUTFBytes(res.length));
		}
	}

}