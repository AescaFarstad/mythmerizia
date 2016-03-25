package minigames.clik_or_crit.data 
{
	
	public class HeroPrototype 
	{
		public var heroSource:Object;
		public var sample:Hero;
		
		public function HeroPrototype(heroSource:Object) 
		{
			this.heroSource = heroSource;
			sample = new Hero();
			sample.load(heroSource, null);
			
		}
		
	}

}