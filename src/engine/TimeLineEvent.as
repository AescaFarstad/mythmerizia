package engine 
{	
	public class TimeLineEvent 
	{
		public var next:TimeLineEvent;
		public var prev:TimeLineEvent;
		public var stamp:int;
		public var callback:Function;
		public var callbackParams:Array;
		public var source:*;
		
		public function TimeLineEvent() 
		{
		}
		
		public function load(stamp:int, callback:Function, callbackParams:Array = null, source:* = null):void
		{
			this.source = source;
			this.callbackParams = callbackParams;
			this.callback = callback;
			this.stamp = stamp;
		}
		
		public function clear():void
		{
			next = null;
			prev = null;
			callback = null;
			callbackParams = null;
			source = null;
		}
	}
}