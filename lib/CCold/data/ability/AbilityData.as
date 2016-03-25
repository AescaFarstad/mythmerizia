package minigames.clik_or_crit.data.ability 
{
	import flash.geom.Point;
	import minigames.clik_or_crit.data.Hero;
	

	public class AbilityData 
	{		
		public var cooldown:int;
		private var hero:Hero;
		public var prototype:AbilityPrototype;
		public var heroTarget:Hero;
		
		public function AbilityData(prototype:AbilityPrototype, hero:Hero) 
		{
			this.hero = hero;
			this.prototype = prototype;
		}
		
		public function setup():void 
		{
			hero.activeAbility = this;
			if (prototype.targetType == AbilityTargetType.HERO)
				heroTarget = hero.ai.getHeroTarget(this);
		}
		
		public function exec():void 
		{
			prototype.exec(hero, this);
			cooldown = prototype.cooldown;
			if (prototype.isAffectedByAttackSpeed)
				cooldown *= 1000 / hero.attackSpeed.divValue;
			hero.activeAbility = null;
		}
		
		public function isAvailable():Boolean 
		{
			return cooldown <= 0;
		}
		
		public function get target():Point
		{
			return prototype.getTarget(hero, this);
		}
	}

}