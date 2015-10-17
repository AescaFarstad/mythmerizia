package util
{
	import components.Label;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	public final class GameInfoPanel extends Sprite
	{
		static private var _instance:GameInfoPanel;
		static public function get instance():GameInfoPanel
		{
			if (!_instance)
				_instance = new GameInfoPanel();
			return _instance;
		}
		
		public var label:Label;
		
		public function GameInfoPanel() 
		{
			mouseChildren = false;
			_createDesign();
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (parent)
				parent.removeChild(this);
		}
		
		private function _createDesign():void
		{
			label = new Label();
			addChild(label);
		}
		
		public function setLayout(x:int, y:int, width:int, height:int):void
		{
			this.x = x;
			this.y = y;
		}
	}

}