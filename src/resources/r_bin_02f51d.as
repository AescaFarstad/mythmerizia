package resources
{	
	import flash.utils.ByteArray;
	
	import flash.display.BitmapData;
	
	public class r_bin_02f51d extends MediaFolder
	{
		public function r_bin_02f51d() 
		{
			 
			__binaryResourceEnum = new <String>["TSPLevels", "settings", "countries", "buildings"];
			
		}
			
		[Embed(source = "../../lib/click_or_crit/buildings.json", mimeType="application/octet-stream")]
		internal var __buildingsClass:Class;		
		internal const __buildingsPath:String = "/click_or_crit/buildings.json";
		////click_or_crit/buildings.json
		public var buildings:ByteArray;
		
		[Embed(source = "../../lib/click_or_crit/countries.json", mimeType="application/octet-stream")]
		internal var __countriesClass:Class;		
		internal const __countriesPath:String = "/click_or_crit/countries.json";
		////click_or_crit/countries.json
		public var countries:ByteArray;
		
		[Embed(source = "../../lib/click_or_crit/settings.json", mimeType="application/octet-stream")]
		internal var __settingsClass:Class;		
		internal const __settingsPath:String = "/click_or_crit/settings.json";
		////click_or_crit/settings.json
		public var settings:ByteArray;
		
		[Embed(source = "../../lib/TSPLevels.json", mimeType="application/octet-stream")]
		internal var __TSPLevelsClass:Class;		
		internal const __TSPLevelsPath:String = "/TSPLevels.json";
		////TSPLevels.json
		public var TSPLevels:ByteArray;
		
	}
}
