package minigames.clik_or_crit.data 
{
	import flash.geom.Point;
	import minigames.clik_or_crit.data.ability.AbilityData;
	import minigames.clik_or_crit.data.ability.AbilityFactory;
	import minigames.clik_or_crit.data.ai.IHeroAI;
	import minigames.clik_or_crit.data.IHeroListener;
	import minigames.clik_or_crit.data.Modifier;
	import minigames.clik_or_crit.data.Party;
	public class Hero 
	{
		public static var STANDARD_COOLDOWN:int = 1000;
		public static var SIZE:Number = 0.05;
		public static var STANDARD_SPEED:Number = 0.001;
		public static var STANDARD_ACCEL:Number = 0.02;
		
		public var hp:Attribute;
		public var strength:Attribute;
		public var agility:Attribute;
		public var intelect:Attribute;
		public var damage:Attribute;
		public var attackSpeed:Attribute;
		public var constitution:Attribute;
		public var critChance:Attribute;
		public var critDamage:Attribute;
		public var cunning:Attribute;
		public var willpower:Attribute;
		public var hpRegen:Attribute;
		
		public var isAlive:Boolean;
		public var name:String;
		
		public var ai:IHeroAI;
		public var party:Party;
		public var target:Hero;
		public var speed:Number;
		public const location:Point = new Point();
		public var origin:Point;
		public var abilities:Vector.<AbilityData> = new Vector.<AbilityData>();
		public var activeAbility:AbilityData;
		
		private var startingCooldown:int;
		
		public var listener:IHeroListener;
		
		private var attributes:Vector.<Attribute> = new Vector.<Attribute>();
		
		public function Hero() 
		{
			hp = createAttribute("health", 0, 0, true, 0);
			strength = createAttribute("strength", 0, 0, false, 0);
			agility = createAttribute("agility", 0, 0, false, 0);
			damage = createAttribute("damage", 0, 0, false, 0, 0.2);
			attackSpeed = createAttribute("attackSpeed", 1000, 0, false, 0, 0.1);
			intelect = createAttribute("intelect", 0, 0, false, 0);
			constitution = createAttribute("constitution", 0, 0, false, 0);
			critChance = createAttribute("critChance", 0, 0, false, 0);
			critDamage = createAttribute("critDamage", 1, 0, false, 0);
			cunning = createAttribute("cunning", 0, 0, false, 0);
			willpower = createAttribute("willpower", 0, 0, false, 0);
			hpRegen = createAttribute("hpRegen", 0, 0, false, 0);
			
			strength.addChild(hp, strengthToHp);
			strength.addChild(critDamage, strengthToCritDamage);
			strength.addChild(damage, strengthToDamage);
			agility.addChild(attackSpeed, agilityToAttackSpeed);
			constitution.addChild(hp, constitutionToHp);
			agility.addChild(critChance, agilityToCritChance);
			cunning.addChild(critChance, cunningToCritChance);
			willpower.addChild(hpRegen, willpowerToHpRegen);
			hpRegen.addChild(hp, hpRegenToHp);
		}
		
		private function hpRegenToHp(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			child.regen = parent.value;
		}
		
		private function willpowerToHpRegen(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			modifier.add = parent.value * 0.001;
		}
		
		private function strengthToCritDamage(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			modifier.add = parent.value * 0.3;
		}
		
		private function cunningToCritChance(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			modifier.add = parent.value * 0.05;
		}
		
		private function agilityToCritChance(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			modifier.add = parent.value * 0.02;
		}
		
		private function constitutionToHp(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			modifier.add = parent.value * 10;
		}
		
		private function agilityToAttackSpeed(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			modifier.add = parent.value * 100;
		}
		
		private function strengthToHp(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			modifier.add = parent.value * 5;
		}
		
		private function strengthToDamage(modifier:Modifier, child:Attribute, parent:Attribute):void 
		{
			modifier.add = parent.value;
		}	
		
		private function createAttribute(name:String, value:Number, maxValue:Number, isReplenishable:Boolean, regen:Number, diviation:Number = NaN):Attribute 
		{
			var attribute:Attribute = new Attribute(name, value);
			attribute.maxValue = maxValue;			
			attribute.isReplenishable = isReplenishable;
			attribute.regen = regen;
			attributes.push(attribute);
			attribute.diviation = diviation;
			attribute.modify("base", value, 0);
			return attribute;
		}
		
		public function load(source:Object, party:Party):void
		{
			name = source.title;
			this.party = party;
			for (var i:int = 0; i < source.attributes.length; i++) 
			{
				this[source.attributes[i].name].modify("init", source.attributes[i].value, 0);
			}			
			for (i = 0; i < source.abilities.length; i++) 
			{
				abilities.push(new AbilityData(AbilityFactory.getAbility(source.abilities[i]), this));
			}
			for (i = 0; i < attributes.length; i++) 
			{
				if (attributes[i].isReplenishable)
					attributes[i].replenishFully();
			}
			isAlive = true;
			speed = STANDARD_SPEED;
			startingCooldown = STANDARD_COOLDOWN * 1000 / attackSpeed.divValue;
			for (i = 0; i < abilities.length; i++) 
			{
				abilities[i].cooldown = startingCooldown;
			}
		}
		
		public function update(timePassed:int):void 
		{
			if (startingCooldown > 0)
				startingCooldown-=timePassed;
			else
			{
				for (var i:int = 0; i < abilities.length; i++) 
				{
					abilities[i].cooldown -= timePassed;
				}
				if (isAlive)
					ai.act(timePassed);				
			}
			for (var j:int = 0; j < attributes.length; j++) 
			{
				if (attributes[j].isReplenishable && attributes[j].value != attributes[j].maxValue)
					attributes[j].update(timePassed);
			}
		}
		
		public function takeHit(dmg:Number, from:Hero, isCrit:Boolean):Number 
		{
			hp.value -= dmg;
			hp.value = Math.max(0, hp.value);
			if (listener)
				listener.onDamaged(dmg, from, isCrit);
			if (hp.value == 0)
			{
				isAlive = false;
				party.onHeroDied(this);
				if (listener)
					listener.onDeath();
			}
			return dmg;
		}
		
	}

}