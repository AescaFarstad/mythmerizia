package minigames.quad 
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import org.osflash.signals.Signal;
	public class QuadModel
	{
		public var numVert:int;
		public var quads:Vector.<Quad> = new <Quad>[];
		
		//public var onTriggered:Signal = new Signal(Quad, int, int)//quad, newIndex, direction;
		
		private var solutionDepth:int;
		private var statesExplored:int;
		
		public var isWin:Boolean;
		
		public var solution:String;
		
		public function QuadModel()
		{
			
		}
		
		public function load(size:int = 4):void
		{
			numVert = size;
			while (!hasSolution())
			{
				var time:int = getTimer();
				trace("creating new solution");
				for (var i:int = 0; i < size; i++)
				{
					quads[i] = new Quad();
					quads[i].index = Math.random() * size;
					quads[i].isRight = quads[i].index == i;
				}/*
				quads[0].index = 1;
				quads[0].isRight = false;*/
				solutionDepth = 0;
				statesExplored = 0;
			}
			trace("steps, depth=", solutionDepth, "explored:", statesExplored, "time:", getTimer() - time);
			
			
			var solution:Vector.<int> = new Vector.<int>();
			for (var j:int = 0; j < quads.length; j++)
			{
				solution[j] = quads[j].index;
			}
			trace("current solution", solution);
			
			isWin = false;
		}
		
		private function hasSolution():Boolean
		{
			if (quads.length == 0)
				return false;
			var exploredStates:Dictionary = new Dictionary();
			
			var state:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < quads.length; i++)
			{
				state[i] = quads[i].index;
			}
			
			if (breadthFirst(new <Vector.<int>>[state], exploredStates))
				return true;
			return false;
		}
		
		private function breadthFirst(frontier:Vector.<Vector.<int>>, exploredStates:Dictionary, depth:int = 0, frontierSolutions:Vector.<String> = null):Boolean
		{
			var newFrontier:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			if (!frontierSolutions)
				frontierSolutions = new <String> [frontier[0].toString()];
				
			var newFrontierSolutions:Vector.<String> = new Vector.<String>();
			
			for (var i:int = 0; i < frontier.length; i++)
			{
				for (var j:int = 0; j < frontier[i].length; j++)
				{
					var statesToCheck:Vector.<Vector.<int>> = new <Vector.<int>>[rotateRight(frontier[i], j), rotateLeft(frontier[i], j)];
					for (var m:int = 0; m < statesToCheck.length; m++)
					{
						if (isFinal(statesToCheck[m]))
						{
							solutionDepth = depth;
							solution = ["Solution:", frontierSolutions[i] + " -> " + j + (m == 0 ? "R" : "L") + " = " + statesToCheck[m]].join(" ");
							trace(solution);
							return true;
						}
						var index:int = getIndex(statesToCheck[m]);
						if (!exploredStates[index])
						{
							exploredStates[index] = true;
							statesExplored++;
							newFrontier.push(statesToCheck[m]);
							newFrontierSolutions.push(frontierSolutions[i] + " -> " + j + (m == 0 ? "R" : "L") + " = " + statesToCheck[m]);
						}
					}
				}
			}
			if (newFrontier.length == 0)
				return false;
			return breadthFirst(newFrontier, exploredStates, depth + 1, newFrontierSolutions);
		}
		
		private function getIndex(state:Vector.<int>):int
		{
			var result:int = 0;
			for (var i:int = 0; i < state.length; i++)
			{
				result += state[i] * Math.pow(state.length, i);
			}
			return result;
		}
		
		private function isFinal(state:Vector.<int>):Boolean
		{
			for (var i:int = 0; i < state.length; i++)
			{
				if (state[i] != i)
					return false;
			}
			return true;
		}
		
		private function rotateLeft(state:Vector.<int>, index:int):Vector.<int>
		{
			var newState:Vector.<int> = state.slice();
			newState[index] = (newState[index] - 1 + state.length) % state.length;
			var tmp:int = newState[0];
			for (var i:int = 0; i < state.length - 1; i++)
			{
				newState[i] = newState[i + 1];
			}
			newState[state.length - 1] = tmp;
			return newState;
		}
		
		private function rotateRight(state:Vector.<int>, index:int):Vector.<int>
		{			
			var newState:Vector.<int> = state.slice();
			newState[index] = (newState[index] + 1) % state.length;
			var tmp:int = newState[state.length - 1];
			for (var i:int = state.length - 1; i > 0; i--)
			{
				newState[i] = newState[i - 1];
			}
			newState[0] = tmp;
			return newState;
		}
		
		public function triggerQuad(quad:Quad, direction:int):void
		{
			quad.index = (quad.index + direction + numVert) % numVert;
			if (direction > 0)
				quads.unshift(quads.pop());
			else
				quads.push(quads.shift());
				
			for (var i:int = 0; i < quads.length; i++)
			{
				quads[i].isRight = quads[i].index == i;
			}
			
			var solution:Vector.<int> = new Vector.<int>();
			for (var j:int = 0; j < quads.length; j++)
			{
				solution[j] = quads[j].index;
			}
			
			checkWinningConditions();
			
			if (!isWin)
			{
				var exploredStates:Dictionary = new Dictionary();
				var state:Vector.<int> = new Vector.<int>();
				for (i = 0; i < quads.length; i++)
				{
					state[i] = quads[i].index;
				}			
				breadthFirst(new <Vector.<int>> [state], exploredStates);
				trace("current solution", solution);				
			}
		}
		
		private function checkWinningConditions():void
		{
			for (var i:int = 0; i < quads.length; i++)
			{
				if (!quads[i].isRight)
					return;
			}
			isWin = true;
		}
		
	}
}