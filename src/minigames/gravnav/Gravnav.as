package minigames.gravnav 
{
	import engine.TimeLineManager;
	import flash.display.Sprite;
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
			new AlertBox(stage, S.format.black(16) + "Доведи зелёный шарик до любого синего квадратика.<##> Управление - стрелочками на клавиатуре.", 
					300, new < String > ["OK"], new < Function > [function():void { } ]);
		}
		
		private function onComplete(e:Event):void 
		{
			view.parent.removeChild(view);
			EnterFramer.removeEnterFrameUpdate(onFrame);
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			logic.update(e.timePassed);
			model.update(e.timePassed);
			view.update(e.timePassed);
		}
		
	}

}