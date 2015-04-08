package minigames.tsp 
{
	
	public class AIInteraction extends BaseInteraction 
	{
		
		public function AIInteraction(model:TSPModel) 
		{
			super(model);
		}
		
		public function grade(length:Number):int 
		{
			var result:int = 0;
			var points:Vector.<int> = getGradingPoints();
			for (var i:int = 0; i < points.length; i++) 
			{
				if (Math.floor(length) <= points[i])
					result++;
			}
			return result;
		}
		
		public function getGradingPoints():Vector.<int>
		{
			return new <int>[solution.length * 1.06, solution.length * 1.03, solution.length];
			
		}
		
		
	}

}