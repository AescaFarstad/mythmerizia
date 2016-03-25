package minigames.clik_or_crit.data 
{
	import flash.geom.Point;
	import minigames.clik_or_crit.data.ai.AIFactory;
	import minigames.clik_or_crit.data.ai.BaseHeroAI;
	
	public class AnimalPrototype extends Hero
	{
		var source:Object;
		
		public function AnimalPrototype() 
		{
			
		}
		
		override public function load(source:Object, party:Party):void 
		{
			this.source = source;
			super.load(source, party);
		}
		
		public function create(party:Party):Hero
		{
			var hero:Hero = new Hero();
			hero.load(source, party);
			var ai:BaseHeroAI = AIFactory.getAI(source.ai);
			ai.load(hero, party.opponent);
			hero.ai = ai;
			
			party.addHero(hero);
			
			
		}
		
	}

}