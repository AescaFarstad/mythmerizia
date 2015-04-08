package components 
{
	
	public class GrayTextButton extends TextButton 
	{
		
		public function GrayTextButton(width:Number, height:Number, text:String, formatName:String, textSize:int, onClick:Function, tag:String="") 
		{
			super(width, height, text, formatName, textSize, onClick, tag);
			
		}
		
		override protected function renderStateDisabled():void 
		{
			graphics.clear();
			graphics.beginFill(0x0, 0.1);
			graphics.drawRoundRect(0, 0, width, height, 10, 10);
			graphics.endFill();
		}
		
		override protected function renderStateIdle():void 
		{
			graphics.clear();
			graphics.beginFill(0x0, 0.6);
			graphics.drawRoundRect(0, 0, width, height, 10, 10);
			graphics.endFill();
		}
		
		override protected function renderStateDown():void 
		{
			graphics.clear();
			graphics.beginFill(0x0, 0.75);
			graphics.drawRoundRect(0, 0, width, height, 10, 10);
			graphics.endFill();
		}
		
		override protected function renderStateOver():void 
		{
			graphics.clear();
			graphics.beginFill(0x0, 0.65);
			graphics.drawRoundRect(0, 0, width, height, 10, 10);
			graphics.endFill();
		}
		
	}

}