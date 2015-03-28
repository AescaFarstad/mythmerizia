package minigames.tsp.solvers 
{
	import tsp.TSPModel;
	import tsp.Node;
	
	public class TSP2OptAnealSolver implements ITSPSolver 
	{
		private var solution:Vector.<Node>;
		private var model:TSPModel;
		
		public function TSP2OptAnealSolver() 
		{
			
		}
		
		public function debugImprove(solution:Vector.<Node>, model:TSPModel, coolingFactor:Number, temperature:Number):void 
		{
			this.model = model;
			this.solution = solution;
			
			aneal(temperature, coolingFactor);
		}
		
		public function improve(solution:Vector.<Node>, model:TSPModel):void 
		{
			this.model = model;
			this.solution = solution;
			var temperature:Number = 50;
			var coolingFactor:Number = 0.190;
			
			aneal(temperature, coolingFactor);
		}
		
		private function aneal(startTemp:Number, coolingFactor:Number):void 
		{
			var itersPositive:int = 0;
			var itersTotal:int = 0
			var cycleIterNum:int = 100;
            var temperature:Number = startTemp;
			var solutionLength:int = solution.length;
            while (temperature > 0.05)
            {
                for (var i:int = 0; i < cycleIterNum; i++)
                {
                    var p1:int = Math.random() * solutionLength;
                    var p2:int = (p1 + 1) % solutionLength;
                    var p0:int = (p1 - 1 + solutionLength) % solutionLength;

                    var p1i:Node = solution[p1];
                    var p2i:Node = solution[p2];

                    var p1p2:Number = p1i.distanceTo(p2i.x, p2i.y);

                    var p3:int = Math.random() * solutionLength;
                    var p4:int = (p3 + 1) % solutionLength;

                    if (p3 == p0 || p3 == p1 || p3 == p2)
                    {
                        continue;
                    }
					
					itersTotal++;

                    var p3i:Node = solution[p3];
                    var p4i:Node = solution[p4];

                    var cost:Number = -p1p2 +
                        p1i.distanceTo(p3i.x, p3i.y) -
                        p3i.distanceTo(p4i.x, p4i.y) +
                        p2i.distanceTo(p4i.x, p4i.y);

                    var tolerance:Number = Math.random();
                    var scaledCost:Number = Math.exp(-cost / temperature);
                    if (scaledCost > tolerance)
                    {
                        reverseSequence(solution, p2, p4);
                        //costBefore = costBefore + cost;
                        itersPositive++;
                    }
                }
                temperature *= coolingFactor;
            }
			//trace("Iters:", itersPositive + "/" + itersTotal);
		}
		
		private function reverseSequence(sequence:Vector.<Node>, from:int, to:int):void
		{
			if ((to - from + sequence.length) % sequence.length < (from - to + sequence.length) % sequence.length)
			{
				var fromP:int = from;
				var toP:int = to;
			}
			else
			{
				fromP = to;
				toP = from + sequence.length;
			}
			for (var i:int = fromP; i < toP && (i < toP - i + fromP); i++) 
			{
				var index1:int = i%sequence.length
				var index2:int = (toP - i + fromP - 1) % sequence.length;
				var tmp:Node = sequence[index1];
				sequence[index1] = sequence[index2];
				sequence[index2] = tmp;							
			}
		}
		
	}

}