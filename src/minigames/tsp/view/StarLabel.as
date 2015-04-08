package minigames.tsp.view 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	
	public class StarLabel extends Sprite 
	{
		
		private var total:int;
		private var numFilled:int;
		private var bitmaps:Vector.<Bitmap>;
		
		public function StarLabel(total:int = 1, filled:int = 1) 
		{
			super();
			bitmaps = new Vector.<Bitmap>();
			
			setStars(total, filled);
		}
		
		private function render():void 
		{
			if (bitmaps.length > total)
			{
				var deleteCount:int = bitmaps.length - total;
				for (var i:int = 0; i < deleteCount; i++) 
				{
					removeChild(bitmaps.pop());
				}
			}
			if (bitmaps.length < total)
			{
				var addCount:int = total - bitmaps.length;
				for (var j:int = 0; j < addCount; j++) 
				{
					var newBitmap:Bitmap = new Bitmap(S.pics.emptyStar);
					addChild(newBitmap);
					newBitmap.x = bitmaps.length * newBitmap.width;
					bitmaps.push(newBitmap);
				}
			}
			for (var k:int = 0; k < bitmaps.length; k++) 
			{
				if (k < numFilled)
					bitmaps[k].bitmapData = S.pics.filledStar;
				else
					bitmaps[k].bitmapData = S.pics.emptyStar;
			}
		}
		
		public function setStars(total:int, filled:int):void
		{
			numFilled = filled;
			this.total = total;
			render();
		}
		
	}

}