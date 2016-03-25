package minigames.clik_or_crit.data.ai 
{
	import minigames.clik_or_crit.data.ability.AbilityData;
	import minigames.clik_or_crit.data.ability.AbilityTargetAlgorithm;
	import minigames.clik_or_crit.data.Hero;
	

	public class PlayerHeroAI extends BaseHeroAI 
	{		
		public function PlayerHeroAI()
		{
			algorithms[AbilityTargetAlgorithm.DEFAULT_AUTOATTACK] = defaultAutoAttackTarget
		}
		
		private function defaultAutoAttackTarget(ability:AbilityData):Hero
		{
			var bestRatio:Number = 0;
			var bestHero:Hero = null;
			for (var i:int = 0; i < opponent.heroes.length; i++) 
			{
				if (!opponent.heroes[i].isAlive)
					continue;
				var ratio:Number = opponent.heroes[i].damage.value * opponent.heroes[i].attackSpeed.value / opponent.heroes[i].hp.value;
				if (ratio > bestRatio)
				{
					bestRatio = ratio;
					bestHero = opponent.heroes[i];
				}
			}
			return bestHero;
		}
		
	}

}