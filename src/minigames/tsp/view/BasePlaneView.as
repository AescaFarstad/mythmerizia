package minigames.tsp.view 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
		
		public function BasePlaneView(interaction:BaseInteraction) 
		{
			super();
			this.interaction = interaction;
			model = interaction.model;
			edgesToView = new Dictionary();
		}
		
		public function render():void 
		{
			renderCounter++;
			
			graphics.clear();
			graphics.lineStyle(1, 0, 0);
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, 800, 600 - x);
			graphics.endFill();
			
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