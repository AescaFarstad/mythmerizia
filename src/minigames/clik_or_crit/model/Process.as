package minigames.clik_or_crit.model 
{
	import engine.IUpdatable;
	import org.osflash.signals.Signal;
	
	public class Process implements IUpdatable
	{
		public var onStarted:Signal = new Signal();
		public var onCompleted:Signal = new Signal();
		
		public var name:String;
		public var duration:int;
		public var left:int;
		
		public function Process(name:String) 
		{
			this.name = name;
		}
		
		
		public function load(duration:int):void
		{
			this.duration = duration;
			left = duration;
			
			onStarted.dispatch();
		}
		
		public function update(timePassed:int):void
		{
			if (left <= 0)
				return;
			left -= timePassed;
			if (left <= 0)
				onCompleted.dispatch();
		}
		
		public function terminate():void 
		{
			
		}
		
		public function get isComplete():Boolean
		{
			return left <= 0;
		}
		
		public function get ratio():Number
		{
			return Math.max(0, (duration - left)) / duration;
		}
		
	}

}