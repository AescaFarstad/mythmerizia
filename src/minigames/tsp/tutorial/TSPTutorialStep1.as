package minigames.tsp.tutorial 
{
	import minigames.tsp.RubberInteraction;
	import minigames.tsp.TSPModel;
	
	
	public class TSPTutorialStep1 extends TSPTutorialStep 
	{
		
		public function TSPTutorialStep1() 
		{
			model = new TSPModel();
			model.init(20, 2, 500, 560);
			super(model);
			
		}
		
	}

}