package minigames.tsp 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import minigames.tsp.solvers.TSP2OptSolver;
	import minigames.tsp.solvers.TSPComboSolver;
	import minigames.tsp.view.BasePlaneView;
	import minigames.tsp.view.TSPGameView;
	import util.HMath;
	
	public class TSPBinder 
	{
		private var model:TSPModel;
		private var interaction:BaseInteraction;
		private var aiSolution:AIInteraction;
		private var view:TSPGameView;
		
		public function TSPBinder() 
		{
			var p:Point = HMath.linesIntersection(new Point( -1, -2), new Point( 1, 2), new Point( -1, 2), new Point(2, -1));
			trace(p.x.toFixed(2), p.y.toFixed(2));
		}
		
		public function start(parent:DisplayObjectContainer):void
		{
			model = new TSPModel();
			model.init(25, 3, 500, 400);
			
			aiSolution = new AIInteraction(model);
			aiSolution.improve(new TSPComboSolver());
			
			interaction = new RubberInteraction(model);
			interaction.loadConvexHull();
			
			view = new TSPGameView();
			parent.addChild(view);
			view.init(model, interaction, aiSolution);
			
			parent.addEventListener(Event.ENTER_FRAME, onFrame);
			parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			view.planeView.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			view.planeView.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			interaction.mouseUp(e.localX, e.localY);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			interaction.mouseDown(e.localX, e.localY);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13)
			{
				model.init(25, 3, 500, 400);
				interaction = new PencilInteraction(model);
				interaction.loadConvexHull();
				aiSolution = new AIInteraction(model);
				aiSolution.improve(new TSPComboSolver());
			}
			if (e.keyCode == 32)
			{
				aiSolution.improve(new TSP2OptSolver());
				interaction.loadSolution(aiSolution.solution);
			}
		}
		
		private function onFrame(e:Event):void 
		{
			interaction.updateInteractable(view.planeView.mouseX, view.planeView.mouseY);
			
			view.giveFeedback(interaction.getFeedback() + " а можно было бы " + model.getLength(aiSolution.solution).toFixed());
			view.update();
		}
		
	}

}