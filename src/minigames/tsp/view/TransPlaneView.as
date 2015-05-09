package minigames.tsp.view 
{
	import minigames.tsp.BaseInteraction;
	import minigames.tsp.Edge;
	import minigames.tsp.SolutionDifference;
	import minigames.tsp.TransInteraction;
	
	
	public class TransPlaneView extends BasePlaneView 
	{
		public static const EDGE_ANIM_DELAY:int = 300;
		
		private var interaction:TransInteraction;
		private var lastDifferenceIndex:int;
		private var goneEdges:Vector.<Edge>;
		private var inited:Boolean;
		private var coreView:TSPCoreGameView;
		private var animations:Vector.<EdgeAnimation>;
		
		public function TransPlaneView(interaction:TransInteraction, coreView:TSPCoreGameView) 
		{
			this.coreView = coreView;
			this.interaction = interaction;
			super(interaction, false);
		}
		
		private function init():void 
		{
			inited = true;
			animations = new Vector.<EdgeAnimation>();
			for (var i:int = 0; i < interaction.edges.length; i++) 
			{
				var anim:EdgeAnimation = new EdgeAnimation();
				anim.init(interaction.edges[i], coreView);
				animations.push(anim);
				addChild(anim);
			}
			lastDifferenceIndex = -1;
		}
		
		override public function render(timePassed:int):void 
		{
			if (!inited)
				init();
			super.render(timePassed);
			
			while (lastDifferenceIndex < interaction.differences.length - 1)
			{
				lastDifferenceIndex++;
				appendDifferentEdges(interaction.differences[lastDifferenceIndex]);
			}
			
			for (var k:int = 0; k < animations.length; k++) 
			{
				animations[k].update(timePassed);
				color = 0x00ff00;
				thickness = 2;
				graphics.lineStyle(thickness, color, 1);
				graphics.moveTo(animations[k].p1.x, animations[k].p1.y);
				graphics.lineTo(animations[k].p2.x, animations[k].p2.y);
			}
			
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
				var alpha:Number = 0.3;
				graphics.lineStyle(thickness, color, alpha);
				graphics.moveTo(interaction.edges[j].p1.x, interaction.edges[j].p1.y);
				graphics.lineTo(interaction.edges[j].p2.x, interaction.edges[j].p2.y);
			}
		}
		
		private function appendDifferentEdges(diff:SolutionDifference):void 
		{
			for (var i:int = 0; i < diff.from.length; i++) 
			{
				for (var j:int = 0; j < animations.length; j++) 
				{
					if (animations[j].lastAppendedEdge == diff.from[i])
					{
						animations[j].appendEdge(diff.to[i], diff.index * EDGE_ANIM_DELAY);
						break;
					}
				}
			}
		}
		
	}

}