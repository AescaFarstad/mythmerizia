package minigames.tsp.view 
{
	import minigames.tsp.BaseInteraction;
	import minigames.tsp.RubberInteraction;
	import minigames.tsp.view.BasePlaneView;
	
	public class RubberPlaneView extends BasePlaneView 
	{
		private var interaction:RubberInteraction;
		
		public function RubberPlaneView(interaction:BaseInteraction) 
		{
			super(interaction);
			this.interaction = interaction as RubberInteraction;
			
		}
		
		override public function render():void 
		{
			super.render();
			
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				if (interaction.interactable == model.nodes[i])
				{
					var radius:int = 7;
					var color:uint = 0xffff00;
				}
				else if (interaction.getEdgeWithPoint(model.nodes[i]))
				{
					radius = 3;
					color = 0x00aa00;
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
			/*
			if (interaction.thirdPoints)
			{
				for (i = 0; i < interaction.thirdPoints.length; i++) 
				{
					graphics.beginFill(0);
					graphics.drawCircle(interaction.thirdPoints[i].x, interaction.thirdPoints[i].y, 2);
					graphics.endFill();
				}
			}*/
			//trace(interaction.edges.length);
			for (var j:int = 0; j < interaction.edges.length; j++) 
			{
				color = 0x00ff00;
				var thickness:int = 1;
				graphics.lineStyle(thickness, color, 1);
				graphics.moveTo(interaction.edges[j].p1.x, interaction.edges[j].p1.y);
				graphics.lineTo(interaction.edges[j].p2.x, interaction.edges[j].p2.y);
			}
			if (interaction.phantomEdges)
			{
				for (j = 0; j < interaction.phantomEdges.length; j++) 
				{
					color = 0xe0e0e0;
					thickness = 2;
					graphics.lineStyle(thickness, color, 1);
					graphics.moveTo(interaction.phantomEdges[j].p1.x, interaction.phantomEdges[j].p1.y);
					graphics.lineTo(interaction.phantomEdges[j].p2.x, interaction.phantomEdges[j].p2.y);
				}
			}
			/*
			if (interaction.pairings)
			{
				for (j = 0; j < interaction.pairings.length; j++) 
				{
					color = 0;
					thickness = 1;
					graphics.lineStyle(thickness, color, 1);
					graphics.moveTo(interaction.pairings[j].x1, interaction.pairings[j].y1);
					graphics.lineTo(interaction.pairings[j].x2, interaction.pairings[j].y2);
				}
			}*/
			
			
			/*
			if (interaction.sourceEdge && interaction.dragNode)
			{
				graphics.lineStyle(2, 0x55bb33, 1);
				graphics.moveTo(interaction.sourceEdge.p1.x, interaction.sourceEdge.p1.y);
				graphics.lineTo(interaction.dragNode.x, interaction.dragNode.y);
				graphics.moveTo(interaction.sourceEdge.p2.x, interaction.sourceEdge.p2.y);
				graphics.lineTo(interaction.dragNode.x, interaction.dragNode.y);
			}
			*/
			var colors:Object = { "0":0xff000000, "1":0x00ff00, "2":0x0000ff };
			if (interaction.dragEdges)
			{
				for (j = 0; j < interaction.dragEdges.length; j++) 
				{
					color = interaction.intersectionEsists ? 0xff2299 : 0x55bb33;/*colors[interaction.dragEdges[j].index.toString()];*///0x55bb33;
					thickness = 2;
					graphics.lineStyle(thickness, color, 1);
					graphics.moveTo(interaction.dragEdges[j].p1.x, interaction.dragEdges[j].p1.y);
					graphics.lineTo(interaction.dragEdges[j].p2.x, interaction.dragEdges[j].p2.y);
				}
			}
			/*
			if (interaction.intersectionPoint)
			{
				graphics.beginFill(0);
				graphics.drawCircle(interaction.intersectionPoint.x, interaction.intersectionPoint.y, 3);
				graphics.endFill();
			}*/
			
		}
	}

}