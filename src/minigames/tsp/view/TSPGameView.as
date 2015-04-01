package minigames.tsp.view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;	
	import minigames.tsp.AIInteraction;
	import minigames.tsp.BaseInteraction;
	import minigames.tsp.PencilInteraction;
	import minigames.tsp.RubberInteraction;
	import minigames.tsp.TSPModel;
	import minigames.tsp.view.BasePlaneView;
	import util.Button;
	
	public class TSPGameView extends Sprite 
	{
		private const PADDING:int = 20;
		
		public var planeView:BasePlaneView;
		
		private var model:TSPModel;
		private var interaction:BaseInteraction;
		private var view:BasePlaneView;
		private var label:Button;
		private var aiInteraction:AIInteraction;
		private var aiView:BasePlaneView;
		
		public function TSPGameView() 
		{
			super();
		}
		
		public function update():void 
		{
			planeView.render();
			if (aiView)
				aiView.render();
		}
		
		public function giveFeedback(text:String):void
		{
			label.text = text;
		}
		
		public function init(model:TSPModel, interaction:BaseInteraction, aiInteraction:AIInteraction):void 
		{
			this.aiInteraction = aiInteraction;
			this.interaction = interaction;
			this.model = model;
			planeView = getPanelView(interaction); 
			addChild(planeView);
			planeView.x = 20;
			planeView.y = 20;
			planeView.render();
			
			label = new Button("", onBtnClick, 800);
			addChild(label);
			label.y = height - label.height;
		}
		
		private function getPanelView(interaction:BaseInteraction):BasePlaneView 
		{
			if (interaction is RubberInteraction)
				return new RubberPlaneView(interaction as RubberInteraction);
			if (interaction is PencilInteraction)
				return new PencilPlaneView(interaction as PencilInteraction);
			return null;
		}
		
		private function onBtnClick(e:Event):void 
		{
			//interaction.loadSolution(aiInteraction.solution);
			aiView = new AIPlaneView(aiInteraction);
			addChild(aiView);
			aiView.x = 20;
			aiView.y = 20;
			setChildIndex(aiView, 0);
			/*
			aiView = new BasePlaneView(interaction);
			addChild(aiView);*/
		}
	}
}