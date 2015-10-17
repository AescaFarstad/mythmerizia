package util 
{
	import components.Label;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ImageButton extends Sprite 
	{
		private static const STATE_IDLE:int = 0;
		private static const STATE_OVER:int = 1;
		private static const STATE_DOWN:int = 2;
		private static const STATE_DISABLED:int = 3;
		
		private var idle:BitmapData;
		private var over:BitmapData;
		private var down:BitmapData;
		private var disabled:BitmapData;
		
		private var bitmap:Bitmap;
		private var label:Label;
		private var _text:String;
		private var _enabled:Boolean = true;
		private var mouseIsDown:Boolean;
		private var mouseIsOver:Boolean;
		private var _state:int;
		private var _onClick:Function;
		
		public function ImageButton(pics:*, onClick:Function, text:String = null) 
		{
			_onClick = onClick;
			idle = pics.idle;
			over = pics.over;
			down = pics.down;
			disabled = pics.disabled;
			
			bitmap = new Bitmap();
			addChild(bitmap);
			bitmap.bitmapData = idle;
			
			label = new Label(Label.CENTER_Align);
			addChild(label);
			this.text = text;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			mouseIsOver = false;
			mouseIsDown = false;
			updateState();
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			mouseIsOver = true;
			updateState();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			mouseIsDown = false;
			if (_state == STATE_DOWN)
				onPrivateClick(e);
			updateState();
		}
		
		private function onPrivateClick(e:MouseEvent):void 
		{
			if (_onClick != null)
				_onClick(e);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			mouseIsDown = true;
			updateState();
		}
		
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void 
		{
			_text = value;
			label.text = text;
			label.x = bitmap.width / 2;
			label.y = (bitmap.height - label.height) / 2;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			updateState();
		}
		
		public function get state():int 
		{
			return _state;
		}
		
		public function set onClick(value:Function):void 
		{
			_onClick = value;
		}
		
		private function updateState():void 
		{
			if (!_enabled)
			{
				_state = STATE_DISABLED;
				bitmap.bitmapData = disabled;
			}
			else if (mouseIsDown)
			{
				_state = STATE_DOWN;
				bitmap.bitmapData = down;
			}
			else if (mouseIsOver)
			{
				_state = STATE_OVER;
				bitmap.bitmapData = over;
			}
			else
			{
				_state = STATE_IDLE;
				bitmap.bitmapData = idle;
			}
		}
		
		public function cleanup():void
		{
			if (parent)
				parent.removeChild(this);
			
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
	}

}