package minigames.tsp.view 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	public class PencilPlaneView extends BasePlaneView 
	{
		public var interaction:PencilInteraction;
		
		public function PencilPlaneView(interaction:PencilInteraction) 
		{
			super(interaction);
			this.interaction = interaction;	
		}
		
		override public function render():void 
		{
			super();
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				if (interaction.interactable == model.nodes[i])
				{
					var radius:int = 7;
					var color:uint = 0xffff00;
				}
				else
				{
					radius = 4;
					color = 0x00ff00;
				}
				graphics.beginFill(color);
				graphics.drawCircle(model.nodes[i].x, model.nodes[i].y, radius);
				graphics.endFill();
			}
			
			if (interaction.workingPoint && !(interaction.interactable is Edge))
			{
				graphics.lineStyle(2, 0xffff00, 1);
				graphics.moveTo(interaction.workingPoint.x, interaction.workingPoint.y);
				graphics.lineTo(mouseX, mouseY);
			}
			
			for (var j:int = 0; j < interaction.edges.length; j++) 
			{
				color = interaction.edges[j] != interaction.interactable ? 0x00ff00 : 0xff0000;
				var thickness:int = interaction.edges[j] != interaction.interactable ? 1 : 2;
				graphics.lineStyle(thickness, color, 1);				
				graphics.moveTo(interaction.edges[j].p1.x, interaction.edges[j].p1.y);
				graphics.lineTo(interaction.edges[j].p2.x, interaction.edges[j].p2.y);
			}
		}		
		
	}

}