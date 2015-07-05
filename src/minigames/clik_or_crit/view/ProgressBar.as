package minigames.clik_or_crit.view 
{
	import flash.display.Sprite;

	public class ProgressBar extends Sprite 
	{
		private var value:Number = 0;
		public var sizeY:Number;
		public var sizeX:Number;
		public var minValue:Number;
		public var maxValue:Number;
		
		public var frameColor:uint;
		public var emptyColor:uint;
		public var fullColor:uint;
		
		public var frameSize:Number = 1;		
		
		
		public function ProgressBar(sizeX:Number = 100, sizeY:Number = 10, maxValue:Number = 1, minValue:Number = 0) 
		{
			super();
			this.sizeY = sizeY;
			this.sizeX = sizeX;
			this.minValue = minValue;
			this.maxValue = maxValue;
			render();
		}
		
		public function setStyle(frameColor:uint, emptyColor:uint, fullColor:uint, frameSize:Number):void
		{
			this.frameSize = frameSize;
			this.fullColor = fullColor;
			this.emptyColor = emptyColor;
			this.frameColor = frameColor;
			render();			
		}
		
		public function setValue(value:Number):void
		{
			this.value = Math.max(minValue, Math.min(maxValue, value));
			render();
		}
		
		private function render():void 
		{
			graphics.clear();
			graphics.beginFill(frameColor);
			graphics.drawRect(0, 0, sizeX, sizeY);
			graphics.endFill();
			
			graphics.beginFill(emptyColor);
			graphics.drawRect(frameSize, frameSize, sizeX - frameSize * 2, sizeY - 2 * frameSize);
			graphics.endFill();
			
			var ratio:Number = (value - minValue) / (maxValue - minValue);
			
			graphics.beginFill(fullColor);
			graphics.drawRect(frameSize, frameSize, (sizeX - frameSize * 2) * ratio, (sizeY - 2 * frameSize));
			graphics.endFill();
		}
		
		public function update():void
		{
			render();
		}
	}

}