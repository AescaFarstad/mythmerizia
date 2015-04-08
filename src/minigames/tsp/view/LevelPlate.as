package minigames.tsp.view 
{
	import components.Label;
	import flash.display.Sprite;
	import minigames.tsp.LevelData;
	import minigames.tsp.TSPPlayerData;
	
	
	public class LevelPlate extends Sprite 
	{
		private static const SIZE_X:int = 250;
		private static const SIZE_Y:int = 80;
		
		private var nameLabel:Label;
		private var starsSprite:Sprite;
		private var stars:StarLabel;
		private var requirementLabel:Label;
		
		public function LevelPlate() 
		{
			super();
			nameLabel = new Label(Label.CENTER_Align);
			nameLabel.x = SIZE_X / 2;
			nameLabel.y = 15;
			addChild(nameLabel);
			
			graphics.beginFill(0, 0.6);
			graphics.drawRoundRect(0, 0, SIZE_X, SIZE_Y, 15, 15);
			graphics.endFill();
			
			starsSprite = new Sprite();
			addChild(starsSprite);
			starsSprite.y = 45;
			
			stars = new StarLabel();
			stars.scaleX = stars.scaleY = 0.5;
			starsSprite.addChild(stars);
			
			requirementLabel = new Label();
			requirementLabel.y = 5;
			starsSprite.addChild(requirementLabel);
			
		}
		
		public function load(levelData:LevelData, playerData:TSPPlayerData):void
		{
			nameLabel.text = S.format.white(15) + levelData.name;
			if (levelData.requires <= playerData.totalStars)
			{
				requirementLabel.text = "";
				stars.setStars(3, levelData.score);
				stars.x = 0;
				var alpha:Number = 0.6;
			}
			else
			{
				requirementLabel.text = S.format.white(14) + playerData.totalStars + " / " + levelData.requires;
				stars.setStars(1, 0);
				stars.x = requirementLabel.width;
				alpha = 0.3;
			}
			starsSprite.x = (SIZE_X - starsSprite.width) / 2;
			
			graphics.clear();
			graphics.beginFill(0, alpha);
			graphics.drawRoundRect(0, 0, SIZE_X, SIZE_Y, 15, 15);
			graphics.endFill();
		}
	}

}