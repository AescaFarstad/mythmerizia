package minigames.tsp.tutorial 
{
	import flash.display.Sprite;
	import minigames.tsp.view.BasePlaneView;
	import minigames.tsp.view.RubberPlaneView;
	import minigames.tsp.view.TSPCoreGameView;
	
	
	public class TSPTutorialView extends TSPCoreGameView 
	{
		public var planeView:BasePlaneView;
		private var interaction:TSPTutorialStep;
		
		public function TSPTutorialView() 
		{
			
		}
		
		public function load(interaction:TSPTutorialStep):void 
		{
			this.interaction = interaction;
			
		}
		
	}

}