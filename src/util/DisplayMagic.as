package util 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	

	public class DisplayMagic 
	{
		public static function setSize(target:*, width:Number, height:Number):void
		{
			target.graphics.lineStyle(0, 0, 0);
			target.graphics.beginFill(0, 0);
			target.graphics.drawRect(0, 0, width, height);
			target.graphics.endFill();
		}
		
	}

}