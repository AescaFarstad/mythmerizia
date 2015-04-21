package minigames.tsp.view 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import minigames.tsp.BaseInteraction;
	import minigames.tsp.Edge;
	import minigames.tsp.TSPModel;
	
	
	public class BasePlaneView extends Sprite 
	{
		private var interaction:BaseInteraction;
		protected var model:TSPModel;
		public var edgesToView:Dictionary;
		private var renderCounter:int;
		private var showLabels:Boolean;
		
		public function BasePlaneView(interaction:BaseInteraction, showLabels:Boolean = true) 
		{
			super();
			this.showLabels = showLabels;
			this.interaction = interaction;
			model = interaction.model;
			edgesToView = new Dictionary();
		}
		
		public function render():void 
		{
			renderCounter++;
			
			var mins:Point = new Point(800, 600);
			var maxs:Point = new Point(0, 0);
			
			for (var j:int = 0; j < model.nodes.length; j++) 
			{
				mins.x = Math.min(model.nodes[j].x, mins.x);
				mins.y = Math.min(model.nodes[j].y, mins.y);
				maxs.x = Math.max(model.nodes[j].x, maxs.x);
				maxs.y = Math.max(model.nodes[j].y, maxs.y);
			}
			maxs.y += 20;
			maxs.x += 20;
			mins.x -= 20;
			mins.y -= 20;
			
			graphics.clear();
			graphics.lineStyle(1, 0, 0);
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(mins.x, mins.y, maxs.x - mins.x, maxs.y - mins.y);
			graphics.endFill();
			
			if (showLabels)
			{
				for (var i:int = 0; i < interaction.edges.length; i++) 
				{
					if (!edgesToView[interaction.edges[i]])
					{
						edgesToView[interaction.edges[i]] = new EdgeView();
						addChild(edgesToView[interaction.edges[i]]);
						edgesToView[interaction.edges[i]].init(interaction.edges[i]);
					}
					edgesToView[interaction.edges[i]].lastUpdate = renderCounter;
				}
				
				for (var edge:* in edgesToView)
				{
					if (edgesToView[edge].lastUpdate < renderCounter)
					{
						edgesToView[edge].cleanUp();
						delete edgesToView[edge];
					}
				}				
			}
			
		}
		
	}

}