package util
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public dynamic class Button extends Sprite 
	{
		private var tf:TextField;
		public static const WIDTH:int = 120;
		public static const HEIGHT:int = 35;
		private var isMouseDown:Boolean;
		private var click:Function;
		private var usedWidth:Number;
		
		public function Button(text:String, click:Function, overrideWidth:Number = NaN) 
		{
			super();
			usedWidth = isNaN(overrideWidth) ? WIDTH : overrideWidth;
			this.click = click;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (click != null)
				addEventListener(MouseEvent.CLICK, click);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.ROLL_OUT, onMouseUp);
			
			tf = getTF(16);
			addChild(tf);
			tf.text = text;
			tf.x = (usedWidth - tf.width) / 2;
			tf.y = (HEIGHT - tf.height) / 2;
			render();
		}
		
		private function render():void
		{
			graphics.clear();
			graphics.beginFill(isMouseDown ? 0x22cc11 : 0x0, isMouseDown ? 0.8 : 0.5);
			graphics.drawRect(0, 0, usedWidth, HEIGHT);
			graphics.endFill();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			isMouseDown = false;
			render();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			isMouseDown = true;
			render();
		}
		
		public function set text(value:String):void
		{
			tf.text = value;
			tf.x = (usedWidth - tf.width) / 2;
			tf.y = (HEIGHT - tf.height) / 2;
		}
		
		public function get text():String
		{
			return tf.text;
		}
		
		public static function getTF(textSize:int = 14, color:uint = 0xffffff):TextField
		{
			var tf:TextField = new TextField();
			var format:TextFormat = tf.getTextFormat();
			format.size = textSize;
			format.bold = true;
			format.color = color;
			tf.setTextFormat(format);
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			return tf;
		}
		
	}

}