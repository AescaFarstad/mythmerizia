package minigames.clik_or_crit.data.ability 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import minigames.clik_or_crit.data.Hero;

	public class AbilityFactory 
	{
		private static const cache:Dictionary = new Dictionary();
		
		public static function getAbility(name:String):AbilityPrototype
		{
			if (cache[name])
				return cache[name];
			var prototype:AbilityPrototype;
			switch (name)
			{
				case "slash":
					{
						prototype = new AbilityPrototype(name, AbilityType.MELEE, AbilityTargetType.HERO, AbilityTargetAlgorithm.DEFAULT_AUTOATTACK);
						prototype.minRange = Hero.SIZE * 1.2;
						prototype.isAffectedByAttackSpeed = true;
						prototype.isAffectedByAttackCrits = true;
						prototype.cooldown = 5000;
						prototype.getTarget = getCachedHeroPosition;
						prototype.exec = dealDamage;
						
						break;
					}
				case "slingshot":
					{
						prototype = new AbilityPrototype(name, AbilityType.MELEE, AbilityTargetType.HERO, AbilityTargetAlgorithm.DEFAULT_AUTOATTACK);
						prototype.minRange = 0.5;
						prototype.isAffectedByAttackSpeed = true;
						prototype.isAffectedByAttackCrits = true;
						prototype.cooldown = 5000;
						prototype.getTarget = getCachedHeroPosition;
						prototype.exec = dealDamage;
						
						break;
					}
			}
			cache[name] = prototype;
			return prototype;
		}
		
		private static function dealDamage(hero:Hero, ability:AbilityData):void 
		{
			var dmg:Number = hero.damage.divValue;
			if (ability.prototype.isAffectedByAttackCrits && hero.critChance.value > Math.random())
			{
				var isCrit:Boolean = true;
				dmg *= hero.critDamage.value;
			}
			
			var realDamage:Number = ability.heroTarget.takeHit(dmg, hero, isCrit);
			//trace(hero.name, "autoattacks", ability.heroTarget.name, "for", realDamage.toFixed(), "who is at", ability.heroTarget.hp.value.toFixed());
		}
		
		private static function getCachedHeroPosition(hero:Hero, ability:AbilityData):Point
		{
			return ability.heroTarget ? ability.heroTarget.location : null;
		}
		
	}

}