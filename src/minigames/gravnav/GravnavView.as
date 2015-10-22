package minigames.gravnav 
{
	import engine.TimeLineManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import util.GameInfoPanel;
	
	
	public class GravnavView extends Sprite 
	{
		public static const CELL_SIZE:int = 20;
		
		private var model:GravnavModel;
		private var logic:UserLogic;
		
		private var heroView:HeroView;
		private var demonViews:Vector.<DemonView>;
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
		}
		
		public function load(model:GravnavModel, logic:UserLogic):void 
		{
			clear();
			alpha = 1;
			addChild(heroView);
			this.logic = logic;
			this.model = model;
			timeline.load();
			heroView.load(model.hero, logic);
			demonViews = new Vector.<DemonView>();
			for (var i:int = 0; i < model.demons.length; i++) 
			{
				var demonView:DemonView = new DemonView(model.demons[i], this, logic, model);
				addChild(demonView);
				demonViews.push(demonView);
			}
			model.addEventListener("demon", onDemon);
			render();
		}
		
		private function onDemon(e:Event):void 
		{
			var demonView:DemonView = new DemonView(model.demons[model.demons.length - 1], this, logic, model);
			addChild(demonView);
			demonViews.push(demonView);
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
			heroView.update(timePassed);
			for (var i:int = 0; i < demonViews.length; i++) 
			{
				demonViews[i].update(timePassed);
			}
			GameInfoPanel.instance.label.text = S.format.black(16) + "Ты выживаешь уже " + model.turnCount.toString() + " ходов!";
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