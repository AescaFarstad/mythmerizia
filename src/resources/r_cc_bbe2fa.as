package resources
{	
	import flash.utils.ByteArray;
	
	import flash.display.BitmapData;
	
	public class r_cc_bbe2fa extends MediaFolder
	{
		public function r_cc_bbe2fa() 
		{
			 
			__bitmapResourceEnum = new <String>["Mine", "Warehouse", "Bank", "Lab"];
			
		}
			
		[Embed(source = "../../lib/click_or_crit/pics/modern_skyscraper.png")]
		internal var __LabClass:Class;		
		internal const __LabPath:String = "/click_or_crit/pics/modern_skyscraper.png";
		////click_or_crit/pics/modern_skyscraper.png
		public var Lab:BitmapData;
		
		[Embed(source = "../../lib/click_or_crit/pics/modern_oldBuilding.png")]
		internal var __BankClass:Class;		
		internal const __BankPath:String = "/click_or_crit/pics/modern_oldBuilding.png";
		////click_or_crit/pics/modern_oldBuilding.png
		public var Bank:BitmapData;
		
		[Embed(source = "../../lib/click_or_crit/pics/military_hangar.png")]
		internal var __WarehouseClass:Class;		
		internal const __WarehousePath:String = "/click_or_crit/pics/military_hangar.png";
		////click_or_crit/pics/military_hangar.png
		public var Warehouse:BitmapData;
		
		[Embed(source = "../../lib/click_or_crit/pics/medieval_mine.png")]
		internal var __MineClass:Class;		
		internal const __MinePath:String = "/click_or_crit/pics/medieval_mine.png";
		////click_or_crit/pics/medieval_mine.png
		public var Mine:BitmapData;
		
	}
}
