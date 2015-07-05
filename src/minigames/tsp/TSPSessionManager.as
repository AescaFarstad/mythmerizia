package minigames.tsp 
{
	import flash.display.DisplayObjectContainer;
	import flash.net.SharedObject;
	import minigames.tsp.TSPGameManager;
	import minigames.tsp.TSPPlayerData;
	import minigames.tsp.tutorial.TSPTutorial;
	import minigames.tsp.view.TSPMenu;
	
	public class TSPSessionManager 
	{
		private static const SAVE_NAME:String = "game2";
		
		private var playerData:TSPPlayerData;
		private var game:TSPGameManager;
		private var tutorial:TSPTutorial;
		private var menu:TSPMenu;
		
		public function TSPSessionManager() 
		{
			playerData = new TSPPlayerData();
		}
		
		public function init(parent:DisplayObjectContainer):void 
		{
			var shared:SharedObject = SharedObject.getLocal(SAVE_NAME);
			if (shared.data.playerData)
				playerData.fromString(shared.data.playerData);
			game = new TSPGameManager();
			game.init(playerData, onSubmit);
			
			if (playerData.tutorialComplete)
			{
				menu = new TSPMenu();
				parent.addChild(menu);
				menu.init(playerData, game);
				menu.load();
			}
			else
			{
				tutorial = new TSPTutorial();
				parent.addChild(tutorial);
				tutorial.load(onComplete);				
			}	
			
			function onComplete():void
			{
				playerData.tutorialComplete = true;
				var shared:SharedObject = SharedObject.getLocal(SAVE_NAME);
				shared.data.playerData = playerData.toString();
				shared.flush();
			}
		}
		
		private function onSubmit(grade:int, level:int):void 
		{
			playerData.data[level].score = Math.max(playerData.data[level].score, grade);
			var shared:SharedObject = SharedObject.getLocal(SAVE_NAME);
			shared.data.playerData = playerData.toString();
			shared.flush();
			menu.load();
		}
		
	}

}