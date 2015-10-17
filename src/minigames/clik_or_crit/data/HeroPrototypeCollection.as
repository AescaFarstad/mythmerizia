package minigames.clik_or_crit.data 
{
	import minigames.clik_or_crit.data.ai.AIFactory;
	import minigames.clik_or_crit.data.ai.BaseHeroAI;
	
	public class HeroPrototypeCollection 
	{
		public var vec:Vector.<HeroPrototype>;		
		
		public function HeroPrototypeCollection(json:Class) 
		{
			vec = new Vector.<HeroPrototype>();
			var source:Object = JSON.parse(new json());
			for (var i:int = 0; i < source.heroes.length; i++) 
			{
				var prototype:HeroPrototype = new HeroPrototype(source.heroes[i]);
				vec.push(prototype);
			}
		}
		
		public function loadAll(party:Party):void 
		{
			for (var i:int = 0; i < vec.length; i++) 
			{
				loadHero(party, vec[i]);
			}
		}
		
		public function loadPack(party:Party, prototypes:Vector.<HeroPrototype>, setter:Function):void 
		{
			for (var i:int = 0; i < prototypes.length; i++) 
			{
				loadHero(party, prototypes[i], setter);
			}
		}
		
		private function loadHero(party:Party, prototype:HeroPrototype, setter:Function = null):void 
		{
			var hero:Hero = new Hero();
			hero.load(prototype.heroSource, party);
			if (setter != null)
				setter(hero);
			var ai:BaseHeroAI = AIFactory.getAI(prototype.heroSource.ai);
			ai.load(hero, party.opponent);
			hero.ai = ai;
			party.addHero(hero);
		}
		
	}

}