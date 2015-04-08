package minigames.tsp.view 
{
	import components.Label;
	import components.TextButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import minigames.tsp.TSPGameManager;
	import minigames.tsp.TSPPlayerData;
	import util.DebugRug;
	
	
	public class TSPMenu extends Sprite 
	{
		private var playerData:TSPPlayerData;
		private var game:TSPGameManager;
		private var buttons:Vector.<LevelPlate>;
		
		public function TSPMenu() 
		{
			super();
			
		}
		
		public function init(playerData:TSPPlayerData, game:TSPGameManager):void 
		{
			this.game = game;
			this.playerData = playerData;
			buttons = new Vector.<LevelPlate>();
			for (var i:int = 0; i < playerData.data.length; i++) 
			{
				var button:LevelPlate = new LevelPlate();
				button.load(playerData.data[i], playerData);
				addChild(button);
				if (i < 6)
				{
					button.y = i * 110 + 40;
					button.x = 20;
				}
				else
				{
					button.y = (i - 6) * 110 + 20;
					button.x = 320;
				}
				buttons.push(button);
				button.addEventListener(MouseEvent.CLICK, onButtonClick);
			}
		}
		
		public function load():void
		{
			for (var i:int = 0; i < playerData.data.length; i++) 
			{
				buttons[i].load(playerData.data[i], playerData);
			}
			visible = true;
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			var index:int = buttons.indexOf(e.currentTarget);
			if (playerData.data[index].requires <= playerData.totalStars)
			{
				game.load(parent, index, load);
				visible = false;				
			}
		}
	}

}