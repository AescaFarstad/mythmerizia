package minigames.clik_or_crit.view 
{
	import flash.display.Sprite;
	import minigames.clik_or_crit.model.CCModel;
	
	public class CCView extends Sprite 
	{
		private var model:CCModel;
		private var currentScreen:*;
		
		public function CCView() 
		{
			super();
		}
		
		public function load(model:CCModel):void 
		{
			this.model = model;
			var scoutingScreen:ScoutingScreen = new ScoutingScreen();
			addChild(scoutingScreen);
			scoutingScreen.load(model);
			currentScreen = scoutingScreen;
		}
		
		public function update(timePassed:int):void 
		{
			currentScreen.update(timePassed);
		}
		
		public function clear():void 
		{
			currentScreen.clear();
			removeChild(currentScreen);
			currentScreen = null;
		}
		
	}

}