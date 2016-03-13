package minigames.exclusion 
{
	import org.osflash.signals.Signal;
	import util.SeededRandom;
	public class ExclusionModel
	{
		public var symbols:Vector.<Symbol> = new Vector.<Symbol>();
		private var random:SeededRandom = new SeededRandom(14135134);
		
		public var onVictory:Signal = new Signal();
		public var isValid:Boolean;
		public var distance:int;
		
		public function ExclusionModel()
		{
			
		}
		
		public function init():void
		{
			var numSymbols:int = random.getInt(4, 7);
			
			for (var i:int = 0; i < numSymbols; i++)
			{
				var symbol:Symbol = new Symbol(random.getInt(2, 5));
				symbols.push(symbol);
			}
			
			for (i = 0; i < numSymbols; i++)
			{
				var numConnections:int = random.getInt(0, numSymbols);
				symbol = null;
				for (var j:int = 0; j < numConnections; j++)
				{
					while (!symbol || symbol == symbols[j] || symbols[j].connections.indexOf(symbol) != -1)						
						symbol = random.getItem(symbols);
					symbols[j].connections.push(symbol);
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
			var distance:int = 0;
			
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
		
		private function nudgeInt(state:int, symbol:int):void
		{
			var val:int = (state / Math.pow(10, symbol)) % ;
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