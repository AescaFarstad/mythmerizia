package engine 
{
	import util.ITimeProvider;
	import util.SimpleLogger;
	import util.SimplePool;
	
	public class TimeLineManager implements ITimeProvider
	{
		static private const POOL:SimplePool = new SimplePool(TimeLineEvent);
		
		private var _firstEvent:TimeLineEvent;
		private var _lastEvent:TimeLineEvent;
		private var _currentStamp:int;
		private var _isUpdateInProgress:Boolean;
		
		public function TimeLineManager() 
		{
		}
		
		public function add(delay:int, callback:Function, callbackParams:Array = null, debugSource:String = null):void
		{
			if (callback == null)
				throw new Error("TimeLineManager: " + debugSource);
			if (_isUpdateInProgress && delay <= 0)
			{
				if (debugSource && debugSource.indexOf("-temporary") == -1)
					SimpleLogger.instance.addLog(debugSource);
				callback.apply(null, callbackParams);
				return;
			}
			delay += _currentStamp;
			var event:TimeLineEvent = POOL.pop();
			event.load(delay, callback, callbackParams, debugSource);
			
			if (_firstEvent)
			{
				// must be inserted before first (rare) or after some existing item (scaning from end is better)
				var eventToInsertAfter:TimeLineEvent = _lastEvent;
				do
				{
					if (eventToInsertAfter.stamp > event.stamp)
						eventToInsertAfter = eventToInsertAfter.prev;
					else
						break;
				}
				while (eventToInsertAfter);
				if (eventToInsertAfter)	// insert between items or at the end
				{
					event.next = eventToInsertAfter.next;
					event.prev = eventToInsertAfter;
					eventToInsertAfter.next = event;
					if (event.next)
						event.next.prev = event;	// inserted in the middle
					else
						_lastEvent = event;			// inserted at the end
				}
				else	// insert at the beginnig
				{
					event.next = _firstEvent;
					_firstEvent.prev = event;
					_firstEvent = event;
				}
			}
			else	// add to empty list
			{
				_firstEvent = event;
				_lastEvent = event;
			}
		}
		
		public function get eventsLength():int
		{
			var length:int = 0;
			var event:TimeLineEvent = _firstEvent;
			while (event)
			{
				length ++;
				event = event.next;
			}
			return length;
		}
		
		public function update(timePassed:int):void
		{
			_currentStamp += timePassed;
			if (_firstEvent)
			{
				_isUpdateInProgress = true;
				
				var event:TimeLineEvent = _firstEvent;
				while (event && event.stamp <= _currentStamp)
				{
					// pre-remove
					_firstEvent = event.next;
					if (_firstEvent)
						_firstEvent.prev = null;
					else
						_lastEvent = null;
					// process
					if (event.source && event.source.indexOf("-temporary") == -1)
						SimpleLogger.instance.addLog(event.source);
					event.callback.apply(null, event.callbackParams);	// WARNING: list changes may occure
					// clear
					event.clear();
					POOL.push(event);
					// next
					event = _firstEvent;
				}
				
				_isUpdateInProgress = false;
			}
		}
		
		public function traceEvents():void
		{			
			if (_firstEvent)
			{
				trace(_currentStamp, "tracing time line manager events:")
				var event:TimeLineEvent = _firstEvent;
				while (event)
				{
					trace(event.stamp, event.source);
					event = event.next;
				}
			}
			else
			{
				trace(_currentStamp, "no events");
			}
		}
		
		public function get eventsAsString():String
		{
			var result:String = "";
			if (_firstEvent)
			{
				var event:TimeLineEvent = _firstEvent;
				while (event)
				{
					result += event.stamp.toString() + ": " + event.source;
					event = event.next;
				}
			}
			else
			{
				result = _currentStamp.toString() + " - no events";
			}
			return result;
		}
		
		public function get currentTime():int 
		{
			return _currentStamp;
		}
		
		public function load():void 
		{
			
		}
		
		public function clear():void 
		{
			var event:TimeLineEvent = _firstEvent;
			while (event)
			{
				var nextEvent:TimeLineEvent = event.next;
				event.clear();
				POOL.push(event);
				event = nextEvent;
			}
			_firstEvent = null;
			_lastEvent = null;
			_isUpdateInProgress = false;
			_currentStamp = 0;
		}
		
		public function get isStable():Boolean
		{
			return _firstEvent == null;
		}
		
	}

}