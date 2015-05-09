package util 
{
	import flash.events.Event;
	
	public class EnterFrameEvent extends Event 
	{
		private var _timePassed:int;
		
		public function EnterFrameEvent(timePassed:int, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_timePassed = timePassed;			
		}
		
		public function get timePassed():int
		{
			return _timePassed;
		}
		
		override public function clone ():Event 
		{
            return new EnterFrameEvent(_timePassed, type, bubbles, cancelable);
        }
	}

}