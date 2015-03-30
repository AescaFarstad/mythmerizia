package minigames.tsp.view 
{
	import minigames.tsp.AISolution;
	import minigames.tsp.BaseInteraction;
	
	
	public class AIPlaneView extends BasePlaneView 
	{
		private var aiSolution:AISolution;
		
		public function AIPlaneView(interaction:BaseInteraction, aiSolution:AISolution) 
		{
			super(interaction);
			this.aiSolution = aiSolution;			
		}
		
		override public function render():void 
		{
			super.render();
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				radius = 3;
				color = 0x0000aa;
				graphics.beginFill(color);
				graphics.drawCircle(model.nodes[i].x, model.nodes[i].y, radius);
				graphics.endFill();
			}
			
			for (var j:int = 0; j < aiSolution.edges.length; j++) 
			{
				color = 0x0000ff;
				var thickness:int = 1;
				graphics.lineStyle(thickness, color, 1);				
				graphics.moveTo(aiSolution.edges[j].p1.x, aiSolution.edges[j].p1.y);
				graphics.lineTo(aiSolution.edges[j].p2.x, aiSolution.edges[j].p2.y);
			}
		}
	}

}