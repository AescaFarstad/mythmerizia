package minigames.gravnav 
{
	import engine.TimeLineManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import util.DebugRug;
	import util.GameInfoPanel;
	
	
	public class GravnavView extends Sprite 
	{
		public static const CELL_SIZE:int = 20;
		
		private var model:GravnavModel;
		private var logic:UserLogic;
		
		private var heroViews:Vector.<HeroView>;
		public var timeline:TimeLineManager;
		
		public function GravnavView() 
		{
			super();
			
		}
		
		public function init():void 
		{
			timeline = new TimeLineManager();
		}
		
		public function load(model:GravnavModel, logic:UserLogic):void 
		{
			clear();
			alpha = 1;
			this.logic = logic;
			this.model = model;
			timeline.load();
			
			heroViews = new Vector.<HeroView>();
			for (var j:int = 0; j < model.balls.length; j++) 
			{
				var view:HeroView = new HeroView();
				view.init(this);
				view.load(model.balls[j], logic);
				addChild(view);
				heroViews.push(view);
			}
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
			}/*
			if (model.futurePoints)
			{
				for (var k:int = 0; k < model.futurePoints.length; k++) 
				{
					var color:uint = model.futurePoints[k].isCovered ? 0xff00ff : 0x220066;
					graphics.beginFill(color, model.futurePoints[k].delay / 3);
					graphics.drawCircle(model.futurePoints[k].x * CELL_SIZE + 10, model.futurePoints[k].y * CELL_SIZE + 10, CELL_SIZE - 12);
					graphics.endFill();
				}				
			}*/
			/*
			for (var k:int = 0; k < model.finalStates.length; k++) 
			{				
				graphics.beginFill(0x9999cc, 1);
				graphics.drawRoundRect(model.finalStates[k].x * CELL_SIZE, model.finalStates[k].y * CELL_SIZE, CELL_SIZE, CELL_SIZE, 12, 12);
				graphics.endFill();
			}*/
		}
		
		public function update(timePassed:int):void 
		{
			//render();
			timeline.update(timePassed);
			for (var j:int = 0; j < heroViews.length; j++) 
			{
				heroViews[j].update(timePassed);
			}
			var text:String = S.format.black(16) + "Прошло " + model.turnCount.toString() + 
					" ходов. Ближайшее решение в ";
			if (model.turnsToNearestSolution >= 0)
				text += model.turnsToNearestSolution + " ходах отсюда.";
			else
				text = S.format.black(16) + "Прошло " + model.turnCount.toString() + "а ближайшее решение... погоди минуточку..."
			GameInfoPanel.instance.label.text = text;
			if (model.lost)
				alpha = 0.2 + 0.7 * (Math.sin(getTimer() / 70) + 1) / 2;
		}
		
		public function clear():void
		{
			graphics.clear();
			while (numChildren > 0)
				removeChild(getChildAt(0));
		}
	}

}