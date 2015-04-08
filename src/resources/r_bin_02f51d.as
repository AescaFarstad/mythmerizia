package resources
{	
	import flash.utils.ByteArray;
	
	import flash.display.BitmapData;
	
	public class r_bin_02f51d extends MediaFolder
	{
		public function r_bin_02f51d() 
		{
			 
			__binaryResourceEnum = new <String>["TSPLevels"];
			
		}
			
		[Embed(source = "../../lib/TSPLevels.json", mimeType="application/octet-stream")]
		internal var __TSPLevelsClass:Class;		
		internal const __TSPLevelsPath:String = "/TSPLevels.json";
		////TSPLevels.json
		public var TSPLevels:ByteArray;
		
	}
}
