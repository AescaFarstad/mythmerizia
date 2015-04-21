package minigames.tsp.view 
{
	import minigames.tsp.BaseInteraction;
	import minigames.tsp.Edge;
	import minigames.tsp.TransInteraction;
	
	
	public class TransPlaneView extends BasePlaneView 
	{
		
		private var interaction:TransInteraction;
		private var lastDifferenceIndex:int;
		private var goneEdges:Vector.<Edge>;
		
		public function TransPlaneView(interaction:TransInteraction) 
		{
			this.interaction = interaction;
			super(interaction, false);
		}
		
		override public function render():void 
		{
			super.render();
			
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				var radius:int;
				var color:uint;
				radius = 4;
				color = 0x00ff00;
				
				graphics.beginFill(color);
				graphics.drawCircle(model.nodes[i].x, model.nodes[i].y, radius);
				graphics.endFill();
			}
			
			//trace(interaction.edges.length);
			for (var j:int = 0; j < interaction.edges.length; j++) 
			{
				color = 0x00ff00;
				var thickness:int = 1;
				graphics.lineStyle(thickness, color, 1);
				graphics.moveTo(interaction.edges[j].p1.x, interaction.edges[j].p1.y);
				graphics.lineTo(interaction.edges[j].p2.x, interaction.edges[j].p2.y);
			}
		}
		
	}

}