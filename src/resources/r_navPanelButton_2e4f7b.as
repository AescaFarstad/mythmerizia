package resources
{	
	import flash.utils.ByteArray;
	
	import flash.display.BitmapData;
	
	public class r_navPanelButton_2e4f7b extends MediaFolder
	{
		public function r_navPanelButton_2e4f7b() 
		{
			 
			__bitmapResourceEnum = new <String>["disabled", "down", "idle", "over"];
			
		}
			
		[Embed(source = "../../lib/pics/overNav.png")]
		internal var __overClass:Class;		
		internal const __overPath:String = "/pics/overNav.png";
		////pics/overNav.png
		public var over:BitmapData;
		
		[Embed(source = "../../lib/pics/idleNav.png")]
		internal var __idleClass:Class;		
		internal const __idlePath:String = "/pics/idleNav.png";
		////pics/idleNav.png
		public var idle:BitmapData;
		
		[Embed(source = "../../lib/pics/downNav.png")]
		internal var __downClass:Class;		
		internal const __downPath:String = "/pics/downNav.png";
		////pics/downNav.png
		public var down:BitmapData;
		
		[Embed(source = "../../lib/pics/disabledNav.png")]
		internal var __disabledClass:Class;		
		internal const __disabledPath:String = "/pics/disabledNav.png";
		////pics/disabledNav.png
		public var disabled:BitmapData;
		
	}
}
