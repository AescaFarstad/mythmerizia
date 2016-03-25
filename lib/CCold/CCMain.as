package minigames.clik_or_crit 
{
	import engine.EngineTimeManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import minigames.clik_or_crit.data.CCModel;
	import minigames.clik_or_crit.view.CCView;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	

	public class CCMain extends Sprite 
	{
		private var model:CCModel;
		private var view:CCView;
		private var timeManager:EngineTimeManager;
		private var input:Input;
		
		public function CCMain() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			model = new CCModel();
			view = new CCView();
			addChild(view);
			view.load(model);
			input = new Input(view, model);
			
			/*
			for (var i:int = 0; i < model.playerParty.heroes.length; i++) 
			{
				trace(model.playerParty.heroes[i].hp.value, model.playerParty.heroes[i].hp.maxValue);
			}		*/
			
			//EnterFramer.addEnterFrameUpdate(onFrame);
			timeManager = new EngineTimeManager();
			timeManager.load(this);
		}
		
		public function update(timePassed:int):void 
		{
			model.update(timePassed);
			view.update(timePassed);
			if (model.isComplete)
				timeManager.clear();
		}
		
	}

}