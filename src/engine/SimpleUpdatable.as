package engine 
{
	public class SimpleUpdatable implements IUpdatable
	{
		private var onUpdate:Function;
		private var onTerminate:Function;
		
		public function load(onUpdate:Function, onTerminate:Function):void
		{
			this.onTerminate = onTerminate;
			this.onUpdate = onUpdate;
		}
			
		public function update(timePassed:int):void 
		{
			onUpdate(timePassed);
		}
		
		public function terminate():void 
		{
			onTerminate();
		}
	}
}