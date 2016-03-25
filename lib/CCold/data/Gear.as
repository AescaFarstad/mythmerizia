package minigames.clik_or_crit.data 
{
	import minigames.clik_or_crit.CCMain;

	public class Gear 
	{
		public var hero:Hero;
		public var items:Vector.<GearItem>;
		public var goldMantissa:Number;
		public var goldMultiplier:Number
		public var level:int;
		public var model:CCModel;
		public var listener:IGearListener
		
		public function Gear() 
		{
			items = new Vector.<GearItem>();
		}
		
		public function load(source:Object, hero:Hero):void
		{
			this.hero = hero;
			model = hero.party.model;
			if (source)
			{
				goldMultiplier = source.multiplier;
				goldMantissa = source.mantissa;				
			}
			if (!source)
				return;
			for (var i:int = 0; source && i < source.items.length; i++) 
			{
				var item:GearItem = new GearItem();
				item.load(source.items[i]);
				items.push(item);
			}
		}
		
		public function get price():Number
		{
			return goldMultiplier * Math.pow(goldMantissa, level);
		}
		
		public function canUpgrade():Boolean
		{
			return price <= model.divine.gold.value;
		}
		
		public function upgrade(item:GearItem):void
		{
			model.divine.gold.value -= price;
			level++;
			item.level++;
			item.apply(hero);
			if (listener)
				listener.onLevelChanged(item);
		}
	}

}