package minigames.tsp 
{
	import engine.TimeLineManager;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import minigames.tsp.solvers.TSP2OptSolver;
	import minigames.tsp.solvers.TSP3OptSolver;
	import minigames.tsp.solvers.TSPComboSolver;
	import minigames.tsp.solvers.TSPSimpleSolver;
	import minigames.tsp.view.TransPlaneView;
	import minigames.tsp.view.TSPGameView;
	import minigames.tsp.view.TSPMenu;
	import util.DebugRug;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
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
		private var timeline:TimeLineManager;
		
		public function TSPGameManager() 
		{
			
		}
		
		public function init(playerData:TSPPlayerData, onSubmit:Function):void 
		{
			this.onSubmit = onSubmit;
			this.playerData = playerData;
			timeline = new TimeLineManager();
		}
		
		public function load(parent:DisplayObjectContainer, levelIndex:int, onComplete:Function):void 
		{
			this.parent = parent;
			this.levelIndex = levelIndex;
			this.onComplete = onComplete;
			timeline.load();
			
			var data:LevelData = playerData.data[levelIndex];
			
			model = new TSPModel();
			model.init(data.points, data.poissonFactor, FIELD_SIZE_X, FIELD_SIZE_Y);
			
			aiInteraction = new AIInteraction(model);
			aiInteraction.solution.improve(new TSPComboSolver());
			aiInteraction.solution.improve(new TSP3OptSolver());
			
			interaction = new RubberInteraction(model);
			interaction.loadConvexHull();/*
			interaction.solveBadly(15);
			interaction.solution.improve(new TSP2OptSolver());*/
			
			if (!view)
			{
				view = new TSPGameView();
				view.init();
			}
			parent.addChild(view);
			view.load(model, interaction, aiInteraction, this);
			
			//parent.addEventListener(Event.ENTER_FRAME, onFrame);
			parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			view.planeView.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			view.planeView.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			EnterFramer.addEnterFrameUpdate(onFrame);
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
			}
			else if (e.keyCode == 32)
			{
				(interaction as TransInteraction).nextStepAllowed = true;
			}
			else if (e.keyCode == 49)
			{
				interaction.solution.improve(new TSPSimpleSolver());
			}
			else
			{
				trace(e.keyCode);
			}
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			timeline.update(e.timePassed);
			if (interaction)
				interaction.updateInteractable(view.planeView.mouseX, view.planeView.mouseY, e.timePassed);
			if (view)
				view.update(e.timePassed);
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
				var solutionVec:Vector.<Node> = interaction.solution.vec.slice();
				var lngth:int = interaction.solution.length;
				if (int(aiInteraction.solution.length) < lngth)
				{
					interaction = new TransInteraction(model, interaction.solution, aiInteraction.solution, onTransInteractionDone);
					view.clear();
					view.load(model, interaction, aiInteraction, this);
					view.blockButtons();					
				}
				else
				{
					goOut();
				}
				/*
				onSubmit(aiInteraction.grade(interaction.solution.length), levelIndex);
				clear();*/			
			}
			
			function onTransInteractionDone():void
			{
				timeline.add(2000 + TransPlaneView.EDGE_ANIM_DELAY * (interaction as TransInteraction).differences.length, goOut);
			}
			
			function goOut():void
			{				
				onSubmit(aiInteraction.grade(lngth), levelIndex);
				clear();
			}
		}
		
		private function clear():void 
		{
			EnterFramer.removeEnterFrameUpdate(onFrame);
			timeline.clear();
			interaction.clearSolution();
			interaction = null;
			parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			view.planeView.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			view.planeView.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			parent.removeChild(view);
			view.clear();
			view = null;
		}
		
		
	}

}