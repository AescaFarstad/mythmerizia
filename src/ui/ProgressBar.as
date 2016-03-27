package ui 
{
	import components.Label;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import util.layout.LayoutUtil;
	
	public class ProgressBar extends Sprite 
	{
		private var label:Label;
		private var value:Number;
		private var bgColor:uint;
		private var fgColor:uint;
		private var getTextFunc:Function;
		private var targetWidth:Number;
		private var targetHeight:Number;
		private var minValue:Number;
		private var maxValue:Number;
		
		public function ProgressBar() 
		{
			super();
			label = new Label();
			addChild(label);
		}
		
		public function init(width:Number, height:Number, minValue:Number, maxValue:Number, bgColor:uint, fgColor:uint, getTextFunc:Function):void
		{
			this.maxValue = maxValue;
			this.minValue = minValue;
			targetWidth = width;
			targetHeight = height;
			this.getTextFunc = getTextFunc;
			this.fgColor = fgColor;
			this.bgColor = bgColor;
			
			label.setMaxX(width);
			value = minValue;
			label.text = getTextFunc(value);
			render();
			LayoutUtil.moveToSameCenter(label, new Rectangle(0, 0, width, height));
		}
		
		public function setValue(value:Number):void
		{
			this.value = value;
			label.text = getTextFunc(value);
			render();
			
		}
		
		private function render():void 
		{
			graphics.clear();
			
			graphics.beginFill(bgColor);
			graphics.drawRect(0, 0, targetWidth, targetHeight);
			graphics.endFill();
			
			
			graphics.beginFill(fgColor);
			graphics.drawRect(0, 0, targetWidth * (value - minValue) / (maxValue - minValue), targetHeight);
			graphics.endFill();
		}
	}

}