package minigames.clik_or_crit.data 
{
	import minigames.clik_or_crit.view.IGearSlotListener;
	public class GearSlot 
	{
		public var gear:Gear;
		public var order:int;
		public var items:Vector.<GearItem>;
		public var currentItem:GearItem;
		public var level:int;
		public var name:String;
		public var model:CCModel;
		
		public var listener:IGearSlotListener;
		
		public function GearSlot() 
		{
			
		}
		
		private function changeLevel(delta:int):void
		{
			var price:Number = changeLevelCost(delta);
			model.divine.gold.value -= price;	
			level+=delta;
			currentItem.apply(gear.hero, level);
			if (listener)
				listener.onLevelChanged();
		}
		
		private function changeLevelCost(delta:int):Number
		{
			return currentItem ? currentItem.price(level + delta) - currentItem.price(level) : 0;
		}
		
		public function switchItem(item:GearItem):void
		{
			var price:Number = switchPrice(item);
			if (currentItem)
				currentItem.clear(gear.hero);
			model.divine.gold.value -= price;
			currentItem = item;
			if (level == 0)
			{
				level++;
				if (listener)
					listener.onLevelChanged();				
			}
			currentItem.apply(gear.hero, level);
			if (listener)
				listener.onSelectionChanged();
		}
		
		public function load(source:Object, gear:Gear):void 
		{
			this.gear = gear;
			model = gear.hero.party.model;
			level = 0;
			name = source.name;
			order = source.order;
			currentItem = null;
			items = new Vector.<GearItem>();
			for (var i:int = 0; i < source.items.length; i++) 
			{
				var item:GearItem = new GearItem();
				item.load(source.items[i], this);
				items.push(item);
			}
			items.sort(compareItems);
		}
		
		private static function compareItems(a:GearItem, b:GearItem):int 
		{
			return a.goldMultiplier > b.goldMultiplier ? -1 : 1;
		}
		
		public function isItemAvailable(item:GearItem):Boolean
		{
			var price:Number = switchPrice(item);
			return model.divine.gold.value >= price;
		}
		
		public function get upgradeCost():Number 
		{
			return changeLevelCost(1);
		}
		
		public function get downgradeCost():Number 
		{
			return changeLevelCost(-1);
		}
		
		public function downgrade():void
		{
			changeLevel(-1);
		}
		
		public function upgrade():void
		{
			changeLevel(1);
		}
		
		public function switchPrice(item:GearItem):Number 
		{
			return currentItem ? -currentItem.price(level) + item.price(level == 0 ? 1 : level) : item.price(level == 0 ? 1 : level);
		}
		
		public function get isDownGradeAvailable():Boolean 
		{
			return level > 0;
		}
		
		public function get isUpgradeAvailable():Boolean 
		{
			return upgradeCost <= model.divine.gold.value;
		}
		
		public function getStatEffectOnThisLevel(stat:GearStat):Number
		{
			return stat.getValue(level);
		}
		
	}

}