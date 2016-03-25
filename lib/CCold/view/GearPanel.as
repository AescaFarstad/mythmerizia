package minigames.clik_or_crit.view 
{
	import components.Label;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import minigames.clik_or_crit.data.Gear;
	import minigames.clik_or_crit.data.GearItem;
	import minigames.clik_or_crit.data.Hero;
	import minigames.clik_or_crit.data.IGearListener;
	
	

	public class GearPanel extends Sprite implements IGearListener
	{
		private var items:Vector.<GearItemView> = new Vector.<GearItemView>();
		private var label:Label;
		private var gear:Gear;
		private var viewByItem:Dictionary;
		
		
		public function GearPanel() 
		{
			label = new Label(Label.CENTER_Align);
			addChild(label);
			label.x = 300;
			viewByItem = new Dictionary();
		}
		
		public function load(hero:Hero, mainView:CCView):void
		{
			gear = hero.gear;
			gear.listener = this;
			items = new Vector.<GearItemView>();
			
			var locations:Vector.<Point> = new <Point>[new Point(20, 20), new Point(300, 20), new Point(20, 300), new Point(300, 300)];
			
			for (var i:int = 0; i < hero.gear.items.length; i++) 
			{
				var panel:GearItemView = new GearItemView();
				addChild(panel);
				panel.x = locations[i].x;
				panel.y = locations[i].y;
				panel.load(hero.gear.items[i], hero.gear, mainView);
				items.push(panel);
				viewByItem[hero.gear.items[i]] = panel;
				panel.addEventListener(MouseEvent.CLICK, onItemClick);
			}
			
			label.text = S.format.edge(15) + "Upgrade price " + Math.ceil(gear.price).toFixed();
			
			graphics.clear();
			graphics.beginFill(0xefefef, 0.9);
			graphics.drawRect(0, 0, width + 5, height + 5);
			graphics.endFill();
		}
		
		private function onItemClick(e:MouseEvent):void 
		{
			if (gear.canUpgrade())
			{
				var itemView:GearItemView = e.currentTarget as GearItemView;
				gear.upgrade(itemView.item);
			}
		}
		
		public function clear():void 
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				items[i].clear();
			}
			items = new Vector.<GearItemView>();
			viewByItem = new Dictionary();
			if (gear)
				gear.listener = null;
			gear = null;
		}
		
		public function update(timePassed:int):void 
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				items[i].update(timePassed);
			}
		}
		
		public function onLevelChanged(item:GearItem):void 
		{
			label.text = S.format.edge(15) + "Upgrade price " + Math.ceil(gear.price).toFixed();
			
			(viewByItem[item] as GearItemView).onLevelChanged();
		}
		
	}

}