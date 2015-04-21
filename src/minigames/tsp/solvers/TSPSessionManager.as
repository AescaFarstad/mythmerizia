package minigames.tsp.solvers 
{
	import flash.display.DisplayObjectContainer;
	import flash.net.SharedObject;
	import minigames.tsp.TSPGameManager;
	import minigames.tsp.TSPPlayerData;
	import minigames.tsp.view.TSPMenu;
	
	public class TSPSessionManager 
	{
		private var playerData:TSPPlayerData;
		private var game:TSPGameManager;
		private var menu:TSPMenu;
		
		public function TSPSessionManager() 
		{
			playerData = new TSPPlayerData();
		}
		
		public function init(parent:DisplayObjectContainer):void 
		{
			var shared:SharedObject = SharedObject.getLocal("game1");
			if (shared.data.playerData)
				playerData.fromString(shared.data.playerData);
			game = new TSPGameManager();
			game.init(playerData, onSubmit);
			
			menu = new TSPMenu();
			parent.addChild(menu);
			menu.init(playerData, game);
			menu.load();
		}
		
		private function onSubmit(grade:int, level:int):void 
		{
			playerData.data[level].score = Math.max(playerData.data[level].score, grade);
			var shared:SharedObject = SharedObject.getLocal("game");
			shared.data.playerData = playerData.toString();
			shared.flush();
			menu.load();
		}
		
	}

}