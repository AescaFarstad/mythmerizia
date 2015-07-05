package util
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public final class BaseAppFPSPanel extends Sprite
	{
		private var _text:TextField;
		private var _lastTimestamp:int;
		private var _frameCountMultipliedBy1000:int;
		
		public function BaseAppFPSPanel() 
		{
			mouseChildren = false;
			visible = false;
			_createDesign();
		}
		
		private function _createDesign():void
		{
			_text = new TextField();
			_text.selectable = false;
			_text.border = true;
			_text.width = 50;
			_text.height = 20;
			_text.backgroundColor = 0x10FFFFFF;
			_text.background = true;
			addChild(_text);
		}
		
		public function setLayout(x:int, y:int, width:int, height:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
			visible = true;
			_startTracking();
		}
		
		public function hide():void
		{
			visible = false;
			_stopTracking();
		}
		
		private function _startTracking():void
		{
			_lastTimestamp = getTimer();
			_frameCountMultipliedBy1000 = 0;
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _stopTracking():void
		{
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event):void 
		{
			var timestamp:int = getTimer();
			_frameCountMultipliedBy1000 += 1000;
			var delta:int = timestamp - _lastTimestamp;
			if (delta >= 1000)
			{
				var fps:Number = _frameCountMultipliedBy1000 / delta;
				_text.text = "FPS: " + fps.toFixed(1);
				_frameCountMultipliedBy1000 = 0;
				_lastTimestamp = timestamp;
			}
		}
		
	}

}