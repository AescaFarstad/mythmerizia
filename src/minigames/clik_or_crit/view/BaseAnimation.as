package minigames.clik_or_crit.view 
{
	import engine.LinkedListNode;
	import engine.AnimUpdater;
	import engine.IAnimUpdatable;
	import flash.display.Sprite;
	
	

	public class BaseAnimation extends Sprite implements IAnimUpdatable 
	{
		protected var _time:int;
		protected var _duration:int;
		
		private var _node:LinkedListNode;
		private var _isPlugedIn:Boolean;
		
		public function BaseAnimation() 
		{
			_node = new LinkedListNode(this);
		}
		
		public function update(timePassed:int):void 
		{
		}
		
		public function forceComplete():void
		{
			_time = _duration;
			update(1);
		}
		
		public function isComplete():Boolean 
		{
			return _time >= _duration;
		}
		
		public function getNode():LinkedListNode 
		{
			return _node;
		}
		
		public function set updater(value:AnimUpdater):void 
		{
		}
		
		public function get isPlugedIn():Boolean 
		{
			return _isPlugedIn;
		}
		
		public function set isPlugedIn(value:Boolean):void 
		{
			_isPlugedIn = value;
		}
	}

}