package minigames.gravnav 
{
	import flash.display.Sprite;
	import util.HMath;
	
	
	public class HeroView extends Sprite implements IHeroListener
	{
		private static const TRAVEL_TIME:int = 50;
		
		private var hero:Hero;
		private var lastX:int;
		private var lastY:int;
		
		private var animX:int;
		private var animY:int;
		private var travelStartedAt:int;
		private var travelDuration:int;
		private var isTraveling:Boolean;
		private var mainView:GravnavView;
		private var logic:UserLogic;
		
		public function init(mainView:GravnavView):void 
		{
			this.mainView = mainView;
			
		}
		
		public function load(hero:Hero, logic:UserLogic):void 
		{
			this.logic = logic;
			this.hero = hero;
			hero.listener = this;
			lastX = hero.x;
			lastY = hero.y;
			x = hero.x * GravnavView.CELL_SIZE;
			y = hero.y * GravnavView.CELL_SIZE;
		}
		
		public function update(timePassed:int):void 
		{			
			if (isTraveling)
			{
				var time:int = Math.min(travelDuration, mainView.timeline.currentTime - travelStartedAt);
				x = HMath.linearInterp(0, animX * GravnavView.CELL_SIZE, travelDuration, lastY, time);
				y = HMath.linearInterp(0, animY * GravnavView.CELL_SIZE, travelDuration, lastY, time);
				if (time >= travelDuration)
				{
					isTraveling = false;
				}
			}
			render();
		}
		
		
		public function onTravel(length:int):void 
		{
			isTraveling = true;
			animX = lastX;
			animY = lastY;
			lastX = hero.x;
			lastY = hero.y;
			travelStartedAt = mainView.timeline.currentTime;
			travelDuration = length * TRAVEL_TIME;
		}
		
		private function render():void 
		{
			graphics.clear();			
			graphics.lineStyle(1, 0, 0);
			var color:uint = logic.isInputEnabled ? 0x55ff55 : 0x00bb00;
			
			graphics.beginFill(color, 1);
			graphics.drawCircle(GravnavView.CELL_SIZE/2 - 1, GravnavView.CELL_SIZE/2 - 1, GravnavView.CELL_SIZE/2 - 1);
			graphics.endFill();
		}
		
	}

}