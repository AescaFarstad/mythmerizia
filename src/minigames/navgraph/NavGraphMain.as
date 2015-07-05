package minigames.navgraph 
{
	import engine.EngineTimeManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	

	public class NavGraphMain extends Sprite 
	{
		private var model:NavSpace;
		private var view:NavView;
		private var editor:Editor;
		private var demo:NavDemo;
		private var timeManager:EngineTimeManager;
		
		public function NavGraphMain() 
		{
			model = new NavSpace();
			model.loadFromString(new Editor.Save());
			view = new NavDemoView(model);
			addChild(view);
			view.x = 0;
			view.y = 0;
			
			demo = new NavDemo(model, view as NavDemoView);
			(view as NavDemoView).demo = demo;
			
			addEventListener(Event.ADDED_TO_STAGE, onaddedToStage);
			
			var firstPoint:Point = new Point();
			while (model.cellMatrix[int(firstPoint.y)][int(firstPoint.x)].isObstacle)
			{				
				firstPoint.x = Math.random() * NavSpace.SIZE_X;
				firstPoint.y = Math.random() * NavSpace.SIZE_Y;
			}
			
			var secondPoint:Point = new Point();
			while (model.cellMatrix[int(secondPoint.y)][int(secondPoint.x)].isObstacle ||
				distance(secondPoint, firstPoint) < (NavSpace.SIZE_X + NavSpace.SIZE_Y) / 3)
			{
				secondPoint.x = Math.random() * NavSpace.SIZE_X;
				secondPoint.y = Math.random() * NavSpace.SIZE_Y;
			}
			
			//trace("length between point", distance(secondPoint, firstPoint));
		}
		
		public function update(timePasssed:int):void
		{
			if (demo)
				demo.onFrame(timePasssed);
		}
		
		private function distance(secondPoint:Point, firstPoint:Point):Number 
		{
			return Math.sqrt((firstPoint.x - secondPoint.x) * (firstPoint.x - secondPoint.x) + 
							(firstPoint.y - secondPoint.y) * (firstPoint.y - secondPoint.y));
		}
		
		private function onaddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onaddedToStage);
			
			editor = new Editor(model, view, demo);
			timeManager = new EngineTimeManager();
			timeManager.load(this);
		}
		
	}

}