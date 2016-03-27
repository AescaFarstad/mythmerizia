package engine 
{
	public class Updater 
	{
		private var _listeners:Vector.<IUpdatable> = new Vector.<IUpdatable>;
		private var _listenersAddQueue:Vector.<IUpdatable> = new Vector.<IUpdatable>;
		private var _updateInProgress:Boolean;
		private var _updateIterator:int;
		private var _updateLength:int;
		private var _terminated:Boolean;
		
		private var _terminationInProgress:Boolean;
		
		///If added during the event, the listender will be called next frame
		private function addListener(listener:IUpdatable):void
		{
			if (_updateInProgress)
			{
				_listenersAddQueue.push(listener);
				return;
			}
			_listeners[_listeners.length] = listener;
		}
		
		///If deleted during the event, the listener is removed immediately
		private function removeListener(listener:IUpdatable):void
		{
			if (_updateInProgress || _terminationInProgress)
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
		}
		
		public function update(timePassed:int):void
		{
			_updateInProgress = true;
			_updateIterator = 0;
			_updateLength = _listeners.length;
			while (_updateIterator < _updateLength && !_terminated)
			{
				_listeners[_updateIterator].update(timePassed);
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
			
			if (_terminated)
				terminate();
		}
		
		public function push(listener:IUpdatable):void 
		{
			if (_listeners.indexOf(listener) == -1 && 
				(!_updateInProgress || _listenersAddQueue.indexOf(listener) == -1))
				addListener(listener);
		}
		
		public function remove(listener:IUpdatable):void 
		{
			if (_listeners.indexOf(listener) != -1 || 
				(_updateInProgress && _listenersAddQueue.indexOf(listener) != -1))
				removeListener(listener);
		}
		
		public function terminate():void
		{
			if (_terminationInProgress)
				return;
				
			_terminated = true;
			if (_updateInProgress)
				return;
			
			//addition -> add to the end. terminate
			//removal -> remove
				
			_terminationInProgress = true;
			for (_updateIterator = 0; _updateIterator < _listeners.length; _updateIterator++) 
			{
				_listeners[_updateIterator].terminate();
			}
			
			_listeners.length = 0;
			_terminated = false;
			_terminationInProgress = false;
		}
		
	}

}