package minigames.gravnav 
{
	import engine.TimeLineManager;
	import flash.display.Sprite;
	import util.GameInfoPanel;
	
	
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
					if (!model.cells[i][j])
					{
						graphics.beginFill(0xcccccc, 1);
						graphics.drawRect(j * CELL_SIZE, i * CELL_SIZE, CELL_SIZE, CELL_SIZE);
						graphics.endFill();
					}
				}
			}
			
			for (var k:int = 0; k < model.finalStates.length; k++) 
			{				
				graphics.beginFill(0x9999cc, 1);
				graphics.drawRoundRect(model.finalStates[k].x * CELL_SIZE, model.finalStates[k].y * CELL_SIZE, CELL_SIZE, CELL_SIZE, 12, 12);
				graphics.endFill();
			}
		}
		
		public function update(timePassed:int):void 
		{
			timeline.update(timePassed);
			heroView.update(timePassed);
			if (model.turnsTillSolution > 0 && model.turnsTillSolution < 7)
				GameInfoPanel.instance.label.text = "Дальше подсказывать не буду.";
			else if (model.turnsTillSolution == -1)
				GameInfoPanel.instance.label.text = "А вот, кажется, и всё. Отсюда уже не выбраться.";
			else
				GameInfoPanel.instance.label.text = "Ближайшее решение в " + (model.turnsTillSolution + 1).toString() + " шагах";
		}
		
	}

}