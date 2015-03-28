package minigames.tsp.solvers 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import tsp.Node;
	import tsp.TSPModel;
	
	
	public class PlaneViewPitter extends Sprite 
	{
		private var simpleTime:int;
		private var anealTime:int;
		private var simpleLength:int;
		private var anealLength:int;
		
		private var frameCounter:int;
		private var totalCount:int = 100;
		
		
		public function PlaneViewPitter() 
		{
			super();
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void 
		{
			trace(frameCounter + "/" + totalCount);
			frameCounter++;
			var task:TSPModel = new TSPModel();
			task.init(25, 4, 460, 360);
			var startingSolution:Vector.<Node> = TSPComboSolver.initWithRandom(task);
			
			var startTime:int = getTimer();
			var bestSolution:Vector.<Node>;
			var bestLength:int = int.MAX_VALUE;
			for (var i:int = 0; i < 4; i++) 
			{
				var simpleSolution:Vector.<Node> = TSPComboSolver.initWithRandom(task);	
				new TSP2OptSolver().improve(simpleSolution, task);
				new TSP2OptSolver().improve(simpleSolution, task);
				new TSP2OptSolver().improve(simpleSolution, task);
				var length:int = task.getLength(simpleSolution);
				if (length < bestLength)
				{
					bestLength = length;
					bestSolution = simpleSolution;
				}
			}
			
			simpleTime+= getTimer() - startTime;
			simpleLength += task.getLength(bestSolution);
			
			startTime = getTimer();
			var anealSolution:Vector.<Node> = startingSolution.slice();
			new TSP2OptAnealSolver().improve(anealSolution, task);
			new TSP2OptSolver().improve(simpleSolution, task);
			anealTime+= getTimer() - startTime;
			anealLength += task.getLength(anealSolution);
			
			if (frameCounter > totalCount)
			{
				removeEventListener(Event.ENTER_FRAME, onFrame);
				trace("simple score:", simpleTime, simpleLength);
				trace("aneal  score:", anealTime, anealLength);
			}
		}
		
	}

}