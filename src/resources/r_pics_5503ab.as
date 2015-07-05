package resources
{	
	import flash.utils.ByteArray;
	
	import flash.display.BitmapData;
	
	public class r_pics_5503ab extends MediaFolder
	{
		public var clickOrCrit:r_clickOrCrit_77dc55 = new r_clickOrCrit_77dc55();
		
		public function r_pics_5503ab() 
		{
			 
			__bitmapResourceEnum = new <String>["emptyStar", "filledStar"];
			
		}
			
		[Embed(source = "../../lib/pics/filledStar.png")]
		internal var __filledStarClass:Class;		
		internal const __filledStarPath:String = "/pics/filledStar.png";
		////pics/filledStar.png
		public var filledStar:BitmapData;
		
		[Embed(source = "../../lib/pics/emptyStar.png")]
		internal var __emptyStarClass:Class;		
		internal const __emptyStarPath:String = "/pics/emptyStar.png";
		////pics/emptyStar.png
		public var emptyStar:BitmapData;
		
	}
}
