package engine 
{
	import flash.display.Sprite;
	import org.osflash.signals.Signal;
	
	public class Animation extends Sprite implements IAnimUpdatable 
	{		
		protected var _time:int;
		protected var _duration:int;
		
		private var _node:LinkedListNode;
		private var _isPlugedIn:Boolean;
		
		public var onUnplugged:Signal = new Signal(Animation);
		public var tag:*;
		
		public function Animation() 
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
			var wasPlugged:Boolean = _isPlugedIn;
			_isPlugedIn = value;
			if (!value && wasPlugged)
				onUnplugged.dispatch(this);
			
		}
	}

}