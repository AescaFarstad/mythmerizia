package minigames.tsp 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import minigames.tsp.solvers.TSP3OptSolver;
	import minigames.tsp.solvers.TSPComboSolver;
	import minigames.tsp.view.TSPGameView;
	import minigames.tsp.view.TSPMenu;
	import util.DebugRug;
	
	public class TSPGameManager 
	{
		private static const FIELD_SIZE_X:int = 500;
		private static const FIELD_SIZE_Y:int = 560;
		
		
		private var playerData:TSPPlayerData;
		private var onComplete:Function;
		private var levelIndex:int;
		private var parent:DisplayObjectContainer;
		private var onSubmit:Function;
		
		
		private var model:TSPModel;
		private var interaction:BaseInteraction;
		private var aiInteraction:AIInteraction;
		private var view:TSPGameView;
		
		public function TSPGameManager() 
		{
			
		}
		
		public function init(playerData:TSPPlayerData, onSubmit:Function):void 
		{
			this.onSubmit = onSubmit;
			this.playerData = playerData;
		}
		
		public function load(parent:DisplayObjectContainer, levelIndex:int, onComplete:Function):void 
		{
			this.parent = parent;
			this.levelIndex = levelIndex;
			this.onComplete = onComplete;
			
			var data:LevelData = playerData.data[levelIndex];
			
			model = new TSPModel();
			model.init(data.points, data.poissonFactor, FIELD_SIZE_X, FIELD_SIZE_Y);
			
			aiInteraction = new AIInteraction(model);
			aiInteraction.solution.improve(new TSPComboSolver());
			aiInteraction.solution.improve(new TSP3OptSolver());
			
			interaction = new RubberInteraction(model);
			interaction.loadConvexHull();
			
			if (!view)
			{
				view = new TSPGameView();
				view.init();
			}
			parent.addChild(view);
			view.load(model, interaction, aiInteraction, this);
			
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
			/*
			if (e.keyCode == 13)
			{
				model.init(25, 3, 500, 400);
				interaction = new RubberInteraction(model);
				interaction.loadConvexHull();
				aiSolution = new AISolution(model);
				aiSolution.improve(new TSPComboSolver());
			}
			if (e.keyCode == 32)
			{
				interaction.solution.improve(new TSP2OptSolver());
				interaction.solution.improve(new TSP3OptSolver());
				//interaction.loadSolution(aiInteraction.solution);
			}
			*/
		}
		
		private function onFrame(e:Event):void 
		{
			interaction.updateInteractable(view.planeView.mouseX, view.planeView.mouseY);			
			view.update();
		}
		
		public function regenerate():void
		{
			var data:LevelData = playerData.data[levelIndex];
			model.init(data.points, data.poissonFactor, FIELD_SIZE_X, FIELD_SIZE_Y);
			interaction.clearSolution();
			interaction.loadConvexHull();
			aiInteraction.solution.improve(new TSPComboSolver());
			aiInteraction.solution.improve(new TSP3OptSolver());
		}
		
		public function revert():void
		{
			interaction.clearSolution();
			interaction.loadConvexHull();
		}
		
		public function submit():void
		{
			if (interaction.solution.isValid())
			{
				onSubmit(aiInteraction.grade(interaction.solution.length), levelIndex);
				clear();				
			}
		}
		
		private function clear():void 
		{
			parent.removeEventListener(Event.ENTER_FRAME, onFrame);
			parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			view.planeView.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			view.planeView.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			parent.removeChild(view);
			view.clear();
		}
		
		
	}

}