package minigames.exclusion 
{
	import org.osflash.signals.Signal;
	public class Symbol
	{
		public var index:int;
		public var modulo:int;
		
		public var connections:Vector.<Symbol> = new Vector.<Symbol>();
		
		public var onIndexChanged:Signal = new Signal();
		
		public function Symbol(modulo:int = 2)
		{
			this.modulo = modulo;
			index = 1;
		}
		
		public function nudge():void
		{
			shade();
			for (var i:int = 0; i < connections.length; i++)
			{
				connections[i].shade();
			}
		}
		
		public function shade():void
		{
			index = (index + 1) % modulo;
			onIndexChanged.dispatch();
		}
	}
}