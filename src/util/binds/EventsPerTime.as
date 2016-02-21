package util.binds 
{
	import org.osflash.signals.Signal;
	import util.ITimeProvider;
	
	public class EventsPerTime implements IBindable
	{
		private var _name:String;
		
		private var _onChange:Signal = new Signal();
		private var _value:Number;
		
		private var _events:Vector.<Event> = new Vector.<Event>();
		private var _timeProvider:ITimeProvider;
		private var _gate:int;
		private var _cursor:int;
		
		public function EventsPerTime(name:String, capacity:int, gate:int, timeProvider:ITimeProvider, tick:Signal)
		{
			_timeProvider = timeProvider;
			_gate = gate;
			this._name = name;
			for (var i:int = 0; i < capacity; i++) 
			{
				_events.push(new Event( -_gate - 1, 0));
			}
			tick.add(update);
		}
		
		public function update(timePassed:int):void
		{
			var currentTime:int = _timeProvider.currentTime;
			var i:int = (_cursor - 1 + _events.length) % _events.length;
			var oldValue:Number = _value;
			_value = 0;
			while (_cursor != i)
			{
				if (currentTime - _events[i].timeStamp <= _gate)
				{
					_value += _events[i].value;
				}
				else
					break;
				
				i = (i - 1 +_events.length) % _events.length;
			}
			if (oldValue != _value)
			{
				_onChange.dispatch();
			}
		}
		
		public function get onChange():Signal
		{
			return _onChange;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function trigger(amount:Number = 1):void
		{
			_events[_cursor].timeStamp = _timeProvider.currentTime;
			_events[_cursor].value = amount;
			_cursor = (_cursor + 1) % _events.length;
		}
		
		public function get lastTimeStamp():int
		{
			return _events[(_cursor - 1 + _events.length) % _events.length].timeStamp;
		}
		
		public function get name():String
		{
			return _name;
		}
	}
}

class Event
{
	public var timeStamp:Number;
	public var value:Number;
	
	public function Event(timeStamp:Number, value:Number)
	{
		this.value = value;
		this.timeStamp = timeStamp;
		
	}
}