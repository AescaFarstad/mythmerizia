package util 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class EnterFramer extends Sprite 
	{
		static private var _instance:EnterFramer;
		
		private var _listeners:Vector.<Function> = new Vector.<Function>;
		private var _listenersAddQueue:Vector.<Function> = new Vector.<Function>;
		private var _updateInProgress:Boolean;
		private var _updateIterator:int;
		private var _updateLength:int;
		
		private var _lastTimeStamp:int;
		
		public function EnterFramer() 
		{
			_instance = this;
		}
		
		static private function get instance():EnterFramer 
		{
			return _instance ? _instance : new EnterFramer();
		}
		
		///If added during the event, the listender will be called next frame
		private function addListener(listener:Function):void
		{
			if (_updateInProgress)
			{
				_listenersAddQueue.push(listener);
				return;
			}
			_listeners[_listeners.length] = listener;
			if (_listeners.length == 1)
			{
				_lastTimeStamp = getTimer();
				addEventListener(Event.ENTER_FRAME, onEnterFrame)
			}
		}
		
		///If deleted during the event, the listener is removed immediately
		private function removeListener(listener:Function):void
		{
			if (_updateInProgress)
			{
				var index:int = _listeners.indexOf(listener);
				if (index == -1)
				{
					//the listener was added during the update. Just don't add it.
					_listenersAddQueue.splice(_listenersAddQueue.indexOf(listener), 1);
					return;
				}
				if (index <= _updateIterator) 
				{
					_listeners[index] = _listeners[_updateIterator];
					_listeners[_updateIterator] = _listeners[_listeners.length - 1];
					_listeners.length--;
					_updateIterator--;
					_updateLength--;
				}
				else
				{
					_listeners[_listeners.indexOf(listener)] = _listeners[_listeners.length - 1];
					_updateLength--;
				}
			}
			else
			{				
				if (_listeners.length == 1)
				{
					_listeners.length = 0;
				}
				else
				{
					_listeners[_listeners.indexOf(listener)] = _listeners[_listeners.length - 1];
					_listeners.length--;
				}
			}
			if (_listeners.length == 0)
				removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		private function onEnterFrame(e:Event):void
		{
			var time:int = getTimer();
			var event:EnterFrameEvent = new EnterFrameEvent(time - _lastTimeStamp, Event.ENTER_FRAME);
			_lastTimeStamp = time;
			_updateInProgress = true;
			_updateIterator = 0;
			_updateLength = _listeners.length;
			while (_updateIterator < _updateLength)
			{
				_listeners[_updateIterator](event);
				_updateIterator++;
			}
			
			_updateInProgress = false;
			if (_listenersAddQueue.length > 0)
			{
				for (var j:int = 0; j < _listenersAddQueue.length; j++) 
				{
					addListener(_listenersAddQueue[j]);
				}
				_listenersAddQueue.length = 0;
			}
		}
		
		static public function addEnterFrameUpdate(listener:Function):void 
		{
			if (instance._listeners.indexOf(listener) == -1 && 
				(!instance._updateInProgress || instance._listenersAddQueue.indexOf(listener) == -1))
				instance.addListener(listener);
		}
		
		static public function removeEnterFrameUpdate(listener:Function):void 
		{
			if (instance._listeners.indexOf(listener) != -1 || 
				(instance._updateInProgress && instance._listenersAddQueue.indexOf(listener) != -1))
				instance.removeListener(listener);
		}
	}

}