package minigames.tsp.view 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import minigames.tsp.BaseInteraction;
	import minigames.tsp.TSPModel;
	
	
	public class BasePlaneView extends Sprite 
	{
		private var interaction:BaseInteraction;
		protected var model:TSPModel;
		
		public function BasePlaneView(interaction:BaseInteraction) 
		{
			super();
			this.interaction = interaction;
			model = interaction.model;
		}
		
		public function render():void 
		{
			graphics.clear();
			graphics.lineStyle(1, 0, 0);
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, 800, 600 - x);
			graphics.endFill();
		}
		
	}

}