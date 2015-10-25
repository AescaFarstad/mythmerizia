package minigames.gravnav 
{
	import engine.TimeLineManager;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import ui.AlertBox;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	
	public class Gravnav extends Sprite 
	{
		private var timeline:TimeLineManager;
		private var model:GravnavModel;	
		private var view:GravnavView;
		private var logic:UserLogic;		
		
		public function Gravnav() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
			load();
		}
		
		public function init():void 
		{
			timeline = new TimeLineManager();
			logic = new UserLogic();
			logic.init(stage);
		}
		
		public function load():void 
		{
			var stage:Stage = stage;
			var tthis:Gravnav = this;
			timeline.load();
			model = new GravnavModel();
			logic.load(model);
			if (!view)
			{
				view = new GravnavView();
				view.init();
			}
			parent.addChild(view);
			view.load(model, logic);
			view.x = (stage.width - view.width) / 2;
			view.y = (stage.height - view.height) / 2;
			
			model.addEventListener(Event.COMPLETE, onComplete)
			EnterFramer.addEnterFrameUpdate(onFrame);
			new AlertBox(stage, S.format.black(16) + "Собери все зелёные шарики в одной клетке! <##> Управление - стрелочками на клавиатуре.", 
					400, new <String> ["OK"], new <Function> [function():void {stage.focus = tthis; } ]);
					
		}
		
		private function onComplete(e:Event):void 
		{
			var stage:Stage = stage;
			var tthis:Gravnav = this;
			view.parent.removeChild(view);
			EnterFramer.removeEnterFrameUpdate(onFrame);
			new AlertBox(stage, S.format.black(16) + "Тебе удалось собрать все шарики за: " + model.turnCount.toString() + " ходов!", 400, 
					new < String > ["Ещё разок!"], new < Function > [function():void { load(); stage.focus = tthis; } ]);
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			logic.update(e.timePassed);
			model.update(e.timePassed);
			view.update(e.timePassed);
		}
		
	}

}