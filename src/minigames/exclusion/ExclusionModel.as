package minigames.exclusion 
{
	import org.osflash.signals.Signal;
	import util.SeededRandom;
	public class ExclusionModel
	{
		public var symbols:Vector.<Symbol>;
		private var random:SeededRandom = new SeededRandom(Math.random() * int.MAX_VALUE);
		
		public var onVictory:Signal = new Signal();
		public var isValid:Boolean;
		public var distance:int;
		
		public function ExclusionModel()
		{
			
		}
		
		public function init():void
		{
			var numSymbols:int = random.getInt(5, 8);
			
			symbols = new Vector.<Symbol>();
			for (var i:int = 0; i < numSymbols; i++)
			{
				var symbol:Symbol = new Symbol(random.getInt(2, 3));
				symbols.push(symbol);
			}
			
			for (i = 0; i < numSymbols; i++)
			{
				var numConnections:int = random.getInt(2, numSymbols);
				symbol = null;
				for (var j:int = 0; symbols[i].connections.length < numConnections; j++)
				{
					while (!symbol || symbol == symbols[i] || symbols[i].connections.indexOf(symbol) != -1)						
						symbol = random.getItem(symbols);
					symbols[i].connections.push(symbol);
				}
			}
			
			validate();
		}
		
		public function nudge(symbol:Symbol):void
		{			
			symbol.nudge();
			for (var i:int = 0; i < symbols.length; i++)
			{
				if (symbols[i].index != 0)
					return;
			}
			onVictory.dispatch();
		}
		
		private function validate():void
		{
			var frontier:Vector.<int> = new Vector.<int>();
			frontier.push(symbolsToState());
			var exploredStates:Vector.<int> = new Vector.<int>();
			this.distance = 0;
			var distance:int = 0;
			isValid = false;
			
			while (frontier.length > 0)
			{
				distance++;
				var newFrontier:Vector.<int> = new Vector.<int>();
				for (var i:int = 0; i < frontier.length; i++)
				{
					for (var j:int = 0; j < symbols.length; j++)
					{
						var res:int = nudgeInt(frontier[i], j);
						if (res == 0)
						{
							isValid = true;
							this.distance = distance;
							return;
						}
						if (frontier.indexOf(res) == -1 && newFrontier.indexOf(res) == -1 && exploredStates.indexOf(res) == -1)
							newFrontier.push(res);
					}
				}
				exploredStates = exploredStates.concat(frontier);
				frontier = newFrontier;
			}
		}
		
		private function nudgeInt(state:int, symbol:int):int
		{
			
			state = nudgeSymbol(state, symbol);
			for (var i:int = 0; i < symbols[symbol].connections.length; i++) 
			{
				state = nudgeSymbol(state, symbols[symbol].connections[i]);
			}
			return state;
			
			function nudgeSymbol(st:int, sym:int):int
			{				
				var val:int = ((state % Math.pow(10, symbol + 1)) / Math.pow(10, symbol));
				st -= Math.pow(10, symbol) * val;
				val = (val + 1) % symbols[sym].modulo;
				st += Math.pow(10, symbol) * val;
				return st;
			}
			
		}
		
		private function symbolsToState():int
		{
			var result:int;
			for (var i:int = 0; i < symbols.length; i++)
			{
				result += Math.pow(10, i) * symbols[i].index;
			}
			return result;
		}
		
	}
}