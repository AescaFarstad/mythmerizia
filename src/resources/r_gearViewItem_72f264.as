package resources
{	
	import flash.utils.ByteArray;
	
	import flash.display.BitmapData;
	
	public class r_gearViewItem_72f264 extends MediaFolder
	{
		public function r_gearViewItem_72f264() 
		{
			 
			__bitmapResourceEnum = new <String>["disabled", "normal", "selected", "nothing"];
			
		}
			
		[Embed(source = "../../lib/pics/GearItemNothing.png")]
		internal var __nothingClass:Class;		
		internal const __nothingPath:String = "/pics/GearItemNothing.png";
		////pics/GearItemNothing.png
		public var nothing:BitmapData;
		
		[Embed(source = "../../lib/pics/GearItemSelected.png")]
		internal var __selectedClass:Class;		
		internal const __selectedPath:String = "/pics/GearItemSelected.png";
		////pics/GearItemSelected.png
		public var selected:BitmapData;
		
		[Embed(source = "../../lib/pics/GearItemNormal.png")]
		internal var __normalClass:Class;		
		internal const __normalPath:String = "/pics/GearItemNormal.png";
		////pics/GearItemNormal.png
		public var normal:BitmapData;
		
		[Embed(source = "../../lib/pics/GearItemDisabled.png")]
		internal var __disabledClass:Class;		
		internal const __disabledPath:String = "/pics/GearItemDisabled.png";
		////pics/GearItemDisabled.png
		public var disabled:BitmapData;
		
	}
}
