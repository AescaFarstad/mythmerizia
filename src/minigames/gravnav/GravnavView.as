package minigames.gravnav 
{
	import engine.TimeLineManager;
	import flash.display.Sprite;
	
	
	public class GravnavView extends Sprite 
	{
		public static const CELL_SIZE:int = 20;
		
		private var model:GravnavModel;
		private var logic:UserLogic;
		
		private var heroView:HeroView;
		public var timeline:TimeLineManager;
		
		public function GravnavView() 
		{
			super();
			
		}
		
		public function init():void 
		{
			heroView = new HeroView();
			heroView.init(this);
			timeline = new TimeLineManager();
			addChild(heroView);
		}
		
		public function load(model:GravnavModel, logic:UserLogic):void 
		{
			this.logic = logic;
			this.model = model;
			timeline.load();
			heroView.load(model.hero, logic);
			render();
		}
		
		private function render():void 
		{
			graphics.clear();
			graphics.lineStyle(1, 0, 0);
			
			for (var i:int = 0; i < model.cells.length; i++) 
			{
				for (var j:int = 0; j < model.cells[i].length; j++) 
				{
					if (!model.cells[j][i])
					{
						graphics.beginFill(0xcccccc, 1);
						graphics.drawRect(i * CELL_SIZE, j * CELL_SIZE, CELL_SIZE, CELL_SIZE);
						graphics.endFill();
					}
				}
			}
		}
		
		public function update(timePassed:int):void 
		{
			timeline.update(timePassed);
			heroView.update(timePassed);
		}
		
	}

}