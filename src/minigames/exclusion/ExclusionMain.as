package minigames.exclusion 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ExclusionMain extends Sprite
	{
		
		public function ExclusionMain()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var model:ExclusionModel = new ExclusionModel();
			var view:ExclusionView = new ExclusionView();
			addChild(view);
			
			while(model.distance == 0 || model.distance < 7 || !model.isValid)
				model.init();
			
			
			
			view.load(model);
			
			view.x = 200;
			view.y = 200;
		}
	}
}