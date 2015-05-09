package util 
{
	import flash.utils.getTimer;
	public class SimpleLogger implements ITimeProvider
	{
		//Meant for debugging.
		
		private static var _instance:SimpleLogger;
		
		private var _timeProvider:ITimeProvider;
		private var _entries:Vector.<String>;
		public var marker:int;
		
		public static function get instance():SimpleLogger
		{
			if (!_instance)
				_instance = new SimpleLogger();
			return _instance;
		}		
		
		public function init(timeProvider:ITimeProvider = null):void
		{
			if (!timeProvider)
				_timeProvider = this;
			else
				_timeProvider = timeProvider;			
		}
		
		public function load():void
		{
			_entries = new Vector.<String>();
			addLog("*start log* " + (new Date()).toString());
		}
		
		public function addLog(data:String):void
		{
			if (!_entries)
				return;
			_entries.push(getTimer().toString() + "\t" + _timeProvider.currentTime.toString() + ":\t" + data);
		}
		
		public function get currentTime():int 
		{
			return -1;
		}
		
		public function get last25():String
		{
			return lastN(25);
		}
		
		///To copy them to clipboard from debugger
		public function get last10():String
		{
			return lastN(10);
		}
		
		///To copy them to clipboard from debugger
		public function get last100():String
		{
			return lastN(100);
		}
		
		///To copy them to clipboard from debugger
		public function get last200():String
		{
			return lastN(200);
		}
		
		///To copy them to clipboard from debugger
		public function get last1000():String
		{
			return lastN(1000);
		}
		
		///To copy them to clipboard from debugger
		public function get fullLog():String
		{
			return lastN(int.MAX_VALUE);
		}
		
		///To copy them to clipboard from debugger
		public function get sinceMarker():String
		{
			var result:String = "";
			if (_entries)
			{
				for (var i:int = marker; i < _entries.length; i++) 
				{
					result += _entries[i] + "\n";
				}
			}
			return result;
		}
		
		private function lastN(N:int):String
		{
			if (N == int.MAX_VALUE)
				N = _entries.length;
			var result:String = "";
			for (var i:int = 0; i < N; i++) 
			{
				if (_entries.length - N + i >= 0)
				{
					result += _entries[_entries.length - N + i] + "\n";
				}
			}
			return result;
		}
		
		public function setMarkerToNow():int
		{
			marker = _entries ? _entries.length : 0;
			return marker;
		}
		
	}

}