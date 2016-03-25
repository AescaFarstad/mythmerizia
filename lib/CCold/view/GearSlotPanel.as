package minigames.clik_or_crit.view 
{
	import components.GrayTextButton;
	import components.Label;
	import components.TextButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import minigames.clik_or_crit.data.GearSlot;
	
	public class GearSlotPanel extends Sprite implements IGearSlotListener
	{
		private var slot:GearSlot;
		private var selectedItem:GearItemView;
		private var levelLabel:Label;
		private var upgradeButton:TextButton;
		private var downgradeButton:TextButton;
		private var options:Vector.<GearItemView> = new Vector.<GearItemView>();
		public var mainView:CCView;
		
		public function GearSlotPanel() 
		{
			selectedItem = new GearItemView();
			addChild(selectedItem);
			
			levelLabel = new Label();
			levelLabel.text = S.format.main(20) + "0";
			addChild(levelLabel);
			levelLabel.x = 140;
			levelLabel.y = 40 - levelLabel.height / 2;
			
			upgradeButton = new GrayTextButton(90, 38, "Upgrade<##>999", "white", 12, onUpgradeClick);
			addChild(upgradeButton);
			upgradeButton.x = 190;
			
			downgradeButton = new GrayTextButton(90, 38, "Downgrade<##>-999", "white", 12, onDowngradeClick);
			addChild(downgradeButton);
			downgradeButton.x = 190;
			downgradeButton.y = upgradeButton.height + 4;
			
		}
		
		private function onDowngradeClick(...params):void 
		{
			if(slot.isDownGradeAvailable)
				slot.downgrade();
		}
		
		private function onUpgradeClick(...params):void 
		{
			if(slot.isUpgradeAvailable)
				slot.upgrade();
		}
		
		public function load(slot:GearSlot, mainView:CCView):void 
		{
			this.mainView = mainView;
			this.slot = slot;
			slot.listener = this;
			onLevelChanged();
			selectedItem.load(slot.currentItem, slot);
			mainView.hintManager.addHint(selectedItem, GearItemHint.instance);
			
			for (var i:int = 0; i < slot.items.length; i++) 
			{
				var view:GearItemView = new GearItemView();
				view.load(slot.items[i], slot);
				addChild(view);
				view.x = 300 + i * 125;
				view.addEventListener(MouseEvent.CLICK, onItemClick);
				mainView.hintManager.addHint(view, GearItemHint.instance);
				options.push(view);
			}			
		}
		
		private function onItemClick(e:MouseEvent):void 
		{
			var itemView:GearItemView = e.currentTarget as GearItemView;
			if (slot.isItemAvailable(itemView.item))
				slot.switchItem(itemView.item);
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < options.length; i++) 
			{
				options[i].update(timePassed);
			}
			selectedItem.update(timePassed);
		}
		
		public function onLevelChanged():void 
		{
			upgradeButton.text = "Upgrade<##>" + slot.upgradeCost.toFixed();
			downgradeButton.text = "Downgrade<##>" + slot.downgradeCost.toFixed();
			downgradeButton.enabled = slot.isDownGradeAvailable;
			upgradeButton.enabled = slot.currentItem != null;
			levelLabel.text = S.format.main(20) + slot.level;
			
			for (var i:int = 0; i < options.length; i++) 
			{
				options[i].load(slot.items[i], slot);
			}
		}
		
		public function onSelectionChanged():void 
		{
			upgradeButton.text = "Upgrade<##>" + slot.upgradeCost.toFixed();
			downgradeButton.text = "Downgrade<##>" + slot.downgradeCost.toFixed();
			upgradeButton.enabled = slot.currentItem != null;
			selectedItem.load(slot.currentItem, slot);
			for (var i:int = 0; i < options.length; i++) 
			{
				options[i].load(slot.items[i], slot);
			}
		}
		
		public function clear():void 
		{
			for (var i:int = 0; i < options.length; i++) 
			{
				options[i].removeEventListener(MouseEvent.CLICK, onItemClick);
				options[i].clear();
				
			}
			options = new Vector.<GearItemView>();
			if (slot)
			{
				slot.listener = null;
				slot = null;				
			}
			if (parent)
				parent.removeChild(this);
		}
		
	}

}