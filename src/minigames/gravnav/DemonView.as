package minigames.gravnav 
{
	import flash.display.Sprite;
	import util.HMath;
	
	
	public class DemonView extends Sprite implements IHeroListener
	{
		private static const TRAVEL_TIME:int = 20;
		
		private var demon:GravDemon;
		private var lastX:int;
		private var lastY:int;
		
		private var animX:int;
		private var animY:int;
		private var travelStartedAt:int;
		private var travelDuration:int;
		private var isTraveling:Boolean;
		private var mainView:GravnavView;
		private var logic:UserLogic;
		private var willCatch:Boolean;
		private var model:GravnavModel;
		private var lineAlpha:Number;
		
		
		public function DemonView(demon:GravDemon, mainView:GravnavView, logic:UserLogic, model:GravnavModel) 
		{
			super();
			this.model = model;
			this.logic = logic;
			this.demon = demon;
			this.mainView = mainView;
			demon.listener = this;
			lastX = demon.x;
			lastY = demon.y;
			x = demon.x * GravnavView.CELL_SIZE;
			y = demon.y * GravnavView.CELL_SIZE;
			
		}
		
		public function update(timePassed:int):void 
		{
			if (isTraveling)
			{
				var time:int = Math.min(travelDuration, mainView.timeline.currentTime - travelStartedAt);
				x = HMath.linearInterp(0, animX * GravnavView.CELL_SIZE, travelDuration, lastX * GravnavView.CELL_SIZE, time);
				y = HMath.linearInterp(0, animY * GravnavView.CELL_SIZE, travelDuration, lastY * GravnavView.CELL_SIZE, time);
				lineAlpha = HMath.linearInterp(0, 0, travelDuration, willCatch ? 1 : 0, time);
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
			lastX = demon.x;
			lastY = demon.y;
			travelStartedAt = mainView.timeline.currentTime;
			travelDuration = length * TRAVEL_TIME;
			travelDuration = Math.min(GravnavModel.MAX_COOLDOWN, travelDuration);
			willCatch = model.hero.x == demon.x && model.hero.y == demon.y;
			if (willCatch)
				trace("willCatch!");
		}
		
		private function render():void 
		{
			graphics.clear();			
			graphics.lineStyle(4, 0xff7722, lineAlpha);
			var color:uint = logic.isInputEnabled ? 0xff5555 : 0xbb0000;
			
			graphics.beginFill(color, 1);
			graphics.drawCircle(GravnavView.CELL_SIZE/2 - 1, GravnavView.CELL_SIZE/2 - 1, GravnavView.CELL_SIZE/2 - 1);
			graphics.endFill();
		}
	}

}