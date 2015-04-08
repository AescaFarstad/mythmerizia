package minigames.tsp.view 
{
	import components.Label;
	import components.TextButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import minigames.tsp.TSPGameManager;
	import minigames.tsp.TSPPlayerData;
	
	
	public class TSPMenu extends Sprite 
	{
		private var playerData:TSPPlayerData;
		private var game:TSPGameManager;
		private var buttons:Vector.<TextButton>;
		
		public function TSPMenu() 
		{
			super();
			
		}
		
		public function init(playerData:TSPPlayerData, game:TSPGameManager):void 
		{
			this.game = game;
			this.playerData = playerData;
			
		}
		
		public function load():void
		{
			buttons = new Vector.<TextButton>();
			for (var i:int = 0; i < playerData.data.length; i++) 
			{
				var button:TextButton = new TextButton(50, 30, playerData.data[i].points + " (" + playerData.data[i].score +  ")", 
														"edge", 20, onButtonClick);
				addChild(button);
				button.x = i * 100;
				buttons.push(button);
			}
		}
		
		private function onButtonClick(button:TextButton):void 
		{
			var index:int = buttons.indexOf(button);
			clear();
			game.load(this, index, load);
		}
		
		private function clear():void 
		{
			if (!buttons)
				return;
			for (var i:int = 0; i < buttons.length; i++) 
			{
				buttons[i].cleanUp();
				removeChild(buttons[i]);
			}
			buttons = null;
		}
	}

}