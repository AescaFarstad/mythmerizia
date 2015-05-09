package minigames.gravnav 
{
	import engine.TimeLineManager;
	import flash.display.Sprite;
	import flash.events.Event;
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
			
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			logic.update(e.timePassed);
			model.update(e.timePassed);
			view.update(e.timePassed);
		}
		
	}

}