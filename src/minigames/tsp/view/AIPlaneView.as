package minigames.tsp.view 
{
	import flash.display.Sprite;
	import minigames.tsp.AIInteraction;
	import minigames.tsp.AISolution;
	import minigames.tsp.BaseInteraction;
	
	
	public class AIPlaneView extends BasePlaneView 
	{
		private var interaction:AIInteraction;
		
		public function AIPlaneView(interaction:BaseInteraction) 
		{
			super(interaction);
			this.interaction = interaction as AIInteraction;
			
			
		}
		
		override public function render():void
		{
			super.render();
			for (var j:int = 0; j < interaction.edges.length; j++) 
			{
				var color:uint = 0x0000ff;
				var thickness:int = 2;
				graphics.lineStyle(thickness, color, 1);
				graphics.moveTo(interaction.edges[j].p1.x, interaction.edges[j].p1.y);
				graphics.lineTo(interaction.edges[j].p2.x, interaction.edges[j].p2.y);
			}
		}
	}

}