package components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	public class TextButton extends Sprite
	{
		public static const IDLE:String = "idle";
		public static const DOWN:String = "down";
		public static const OVER:String = "over";
		public static const DISABLED:String = "disabled";
		
		private var _text:String;
		private var _enabled:Boolean = true;
		public var onClick:Function;
		private var _formatName:String;
		private var _textSize:int;
		protected var label:Label;
		private var hitZone:Sprite;
		private var _state:String;
		public var tag:String;
		
		private var mouseIsOver:Boolean = false;
		private var mouseIsDown:Boolean = false;		
		
		public function TextButton(width:Number, height:Number, text:String, formatName:String, textSize:int, onClick:Function, tag:String="")
		{
			this.tag = tag;
			this.onClick = onClick;
			this._textSize = textSize;
			this._formatName = formatName;
			this._text = text;
			
			_state = IDLE;
			
			hitZone = new Sprite();
			addChild(hitZone);			
			hitZone.graphics.beginFill(0x000000, 0);
			hitZone.graphics.drawRect(0, 0, width, height);
			hitZone.graphics.endFill();
			hitZone.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			hitZone.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			hitZone.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			hitZone.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);			
			
			label = new Label(Label.CENTER_Align, width, height);
			addChild(label);
			label.text = getText();
			label.x = width * 0.5;
			label.y = (height - label.height) * 0.5;
			
			checkState();
		}
		
		protected function getText():String 
		{
			return "<#" + formatName + "#" + textSize.toString() + "#:" + text;
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			mouseIsOver = false;
			mouseIsDown = false;
			checkState();
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			mouseIsOver = true;
			checkState();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (state==DOWN && onClick != null)
			{
				onClick(this);
			}
			mouseIsDown = false;
			checkState();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			mouseIsDown = true;
			checkState();
		}
		
		private function checkState():void
		{
			if (!_enabled)
			{
				_state = DISABLED;
				renderStateDisabled();
				return;
			}
			if (!mouseIsOver)
			{
				_state = IDLE;
				renderStateIdle();
				return;
			}
			if (mouseIsDown)
			{
				_state = DOWN;
				renderStateDown();
				return;
			}
			else 
			{
				_state = OVER;
				renderStateOver();
				return;
			}
		}
		
		protected function renderStateOver():void 
		{
			
		}
		
		protected function renderStateDown():void 
		{
			
		}
		
		protected function renderStateIdle():void 
		{
			
		}
		
		protected function renderStateDisabled():void 
		{
			
		}
		
		
		public function cleanUp():void
		{
			while (numChildren)
			{
				removeChildAt(0);
			}
			hitZone.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			hitZone.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			hitZone.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			hitZone.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		//Getters, Setters
		
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void 
		{
			_text = value;
			label.text = getText();
		}
				
		public function get formatName():String 
		{
			return _formatName;
		}
		
		public function set formatName(value:String):void 
		{
			if (_formatName != value)
			{
				_formatName = value;
				label.text = getText();
			}			
		}
		
		public function get textSize():int 
		{
			return _textSize;
		}
		
		public function set textSize(value:int):void 
		{
			if (_textSize != value)
			{
				_textSize = value;
				label.text = getText();
			}
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			checkState();
		}
	}
}