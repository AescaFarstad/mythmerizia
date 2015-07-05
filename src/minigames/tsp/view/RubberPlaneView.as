package minigames.tsp.view 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import minigames.tsp.BaseInteraction;
	import minigames.tsp.Edge;
	import minigames.tsp.Node;
	import minigames.tsp.RubberInteraction;
	import minigames.tsp.view.BasePlaneView;
	
	public class RubberPlaneView extends BasePlaneView 
	{
		private var interaction:RubberInteraction;
		private var time:int;
		
		public function RubberPlaneView(interaction:BaseInteraction) 
		{
			super(interaction);
			this.interaction = interaction as RubberInteraction;
			
		}
		
		override public function render(timePassed:int):void 
		{
			time+= timePassed;
			super.render(timePassed);
			
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				var radius:int;
				var color:uint;
				var hasEdges:Boolean = interaction.getEdgeWithNode(model.nodes[i]) != null;
				if (interaction.interactable == model.nodes[i] && hasEdges)
				{
					var node:Node = interaction.interactable as Node;
					radius = 6;
					color = 0xff0000;
					var topCorner:Point = new Point(node.x - radius / Math.SQRT2, node.y - radius / Math.SQRT2);
					graphics.lineStyle(3, color, 1);
					graphics.moveTo(topCorner.x - 2, topCorner.y - 2);
					graphics.lineTo(topCorner.x - 2 + radius * 2, topCorner.y - 2 + radius * 2);
					graphics.moveTo(topCorner.x - 2, topCorner.y - 2 + radius * 2);
					graphics.lineTo(topCorner.x - 2 + radius * 2, topCorner.y - 2);
					graphics.lineStyle(0, color, 0);
					continue;
				}
				else if (hasEdges)
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
			
			//trace(interaction.edges.length);
			for (var j:int = 0; j < interaction.edges.length; j++) 
			{
				if (interaction.intersectedEdges && interaction.intersectedEdges.indexOf(interaction.edges[j]) != -1/* || 
						interaction.edges[j] == interaction.interactable as Edge && interaction.dragNode*/)
					continue;
				color = interaction.interactable == interaction.edges[j] ? 0x00aa00 : 0x00ff00;
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
			if (interaction.intersectedEdges)
			{
				for (j = 0; j < interaction.intersectedEdges.length; j++) 
				{
					color = 0xff0000;
					thickness = 3;
					var lineAlpha:Number = (Math.sin(time / 500 * Math.PI * 2) + 1)/2;
					graphics.lineStyle(thickness, color, lineAlpha);
					graphics.moveTo(interaction.intersectedEdges[j].p1.x, interaction.intersectedEdges[j].p1.y);
					graphics.lineTo(interaction.intersectedEdges[j].p2.x, interaction.intersectedEdges[j].p2.y);
				}
			}
			
			if (interaction.deleteEdges)
			{
				for (j = 0; j < interaction.deleteEdges.length; j++) 
				{
					color = 0xff0000//0x4444ff;
					thickness = 4;
					lineAlpha = (Math.sin(time / 500 * Math.PI * 2) + 1)/2;
					graphics.lineStyle(thickness, color, lineAlpha);
					graphics.moveTo(interaction.deleteEdges[j].p1.x, interaction.deleteEdges[j].p1.y);
					graphics.lineTo(interaction.deleteEdges[j].p2.x, interaction.deleteEdges[j].p2.y);
				}
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
			/*if (interaction.thirdEdges)
			{
				for (j = 0; j < interaction.thirdEdges.length; j++) 
				{
					if (interaction.edges.indexOf(interaction.thirdEdges[j]) != -1)
						continue;
					color = 0x606060;
					thickness = 1;
					graphics.lineStyle(thickness, color, 1);
					graphics.moveTo(interaction.thirdEdges[j].p1.x, interaction.thirdEdges[j].p1.y);
					graphics.lineTo(interaction.thirdEdges[j].p2.x, interaction.thirdEdges[j].p2.y);
				}
			}*/
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
			/*
			var bounds:Rectangle = getBounds(this);
			graphics.beginFill(0x0, 0.4);
			graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			graphics.endFill();
			trace(bounds.x, bounds.y, bounds.width, bounds.height);*/
		}
	}

}