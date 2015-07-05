package minigames.clik_or_crit.data.ai 
{
	import minigames.clik_or_crit.data.ability.AbilityData;
	import minigames.clik_or_crit.data.ability.AbilityTargetAlgorithm;
	import minigames.clik_or_crit.data.Hero;
	

	public class AnimalHeroAI extends BaseHeroAI 
	{
		
		public function AnimalHeroAI()
		{
			algorithms[AbilityTargetAlgorithm.DEFAULT_AUTOATTACK] = defaultAutoAttackTarget
		}
		
		private function defaultAutoAttackTarget(ability:AbilityData):Hero 
		{
			var options:Vector.<Hero> = new Vector.<Hero>();
			for (var i:int = opponent.heroes.length - 1; i >= 0; i--) 
			{
				if (opponent.heroes[i].isAlive)
					options.push(opponent.heroes[i]);
			}
			return options.length == 0 ? null : options[int(Math.random() * options.length)];
		}
		
	}

}