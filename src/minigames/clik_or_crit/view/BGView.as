package minigames.clik_or_crit.view 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import minigames.clik_or_crit.model.CCModel;
	
	public class BGView extends Sprite 
	{
		[Embed(source = "../../../../lib/click_or_crit/sources/map tiles/8x-3-0-0.png")]
		private var tempPic:Class;
		
		private var bgImage:Bitmap;
		
		public function BGView() 
		{
			super();
			bgImage = new tempPic();
			addChild(bgImage);
		}
		
		public function render(model:CCModel, vp:ViewPort):void 
		{			
			bgImage.scaleX = vp.scale/ bgImage.bitmapData.width;
			bgImage.scaleY = vp.scale/ bgImage.bitmapData.height;
			bgImage.x = vp.gameToStage(0, 0).x;
			bgImage.y = vp.gameToStage(0, 0).y;
		}
		
	}

}