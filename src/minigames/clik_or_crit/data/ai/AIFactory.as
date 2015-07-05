package minigames.clik_or_crit.data.ai 
{
	

	public class AIFactory 
	{
		public static function getAI(name:String):BaseHeroAI
		{
			switch(name)
			{
				case "player": return new PlayerHeroAI();
				case "NPC": return new AnimalHeroAI();
			}
			return null;
		}
		
	}

}