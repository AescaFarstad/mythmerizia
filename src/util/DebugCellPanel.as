package util 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	
	public class DebugCellPanel extends Sprite 
	{		
		private var _text:TextField;
		public var origin:Point = new Point();
		public var size:int = 20;
		
		public function DebugCellPanel() 
		{
			mouseChildren = false;
			visible = false;
			
			_text = new TextField();
			_text.selectable = false;
			_text.border = true;
			_text.width = 40;
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
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			_text.text = Math.floor((stage.mouseX - origin.x) / size).toFixed() + ":" + Math.floor((stage.mouseY - origin.y) / size).toFixed();
		}
		
		private function _stopTracking():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
	}

}