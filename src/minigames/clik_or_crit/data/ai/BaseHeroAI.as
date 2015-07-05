package minigames.clik_or_crit.data.ai 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import minigames.clik_or_crit.data.ability.AbilityData;
	import minigames.clik_or_crit.data.ai.IHeroAI;
	import minigames.clik_or_crit.data.Hero;
	import minigames.clik_or_crit.data.Party;
	

	public class BaseHeroAI implements IHeroAI 
	{
		public var hero:Hero;
		public var opponent:Party;
		protected var algorithms:Dictionary = new Dictionary();
		
		public function BaseHeroAI() 
		{
			
		}
		
		public function load(hero:Hero, opponent:Party):void
		{
			this.opponent = opponent;
			this.hero = hero;
		}
		
		public function act(timePassed:int):void 
		{
			var target:Point = hero.activeAbility && hero.activeAbility.target ? hero.activeAbility.target : hero.origin;
			var distanceToTarget:Number = Math.sqrt((target.x - hero.location.x) * (target.x - hero.location.x) + 
													(target.y - hero.location.y) * (target.y - hero.location.y));
			var effectiveSpeed:Number = Math.min(hero.speed * timePassed, distanceToTarget);
			if (effectiveSpeed > Hero.SIZE / 5)
			{
				var direction:Number = Math.atan2(target.y - hero.location.y, target.x - hero.location.x);
				hero.location.x += Math.cos(direction) * effectiveSpeed;
				hero.location.y += Math.sin(direction) * effectiveSpeed;
			}
			
			if (hero.activeAbility && hero.activeAbility.target && distanceToTarget < hero.activeAbility.prototype.minRange + effectiveSpeed)
			{
				hero.activeAbility.exec();
				hero.speed = Hero.STANDARD_SPEED;
				hero.target = null;
			}
			else if (!hero.activeAbility || !hero.activeAbility.target)
			{
				for (var i:int = 0; i < hero.abilities.length; i++) 
				{
					if (hero.abilities[i].isAvailable())
					{
						hero.abilities[i].setup();
					}
				}
			}
		}
		
		public function getHeroTarget(ability:AbilityData):Hero 
		{
			if (algorithms[ability.prototype.targetingAlgorithm])
			{
				return algorithms[ability.prototype.targetingAlgorithm](ability);
			}
			return null;
		}
		
		
		
	}

}