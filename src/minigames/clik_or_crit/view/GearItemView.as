package minigames.clik_or_crit.view 
{
	import components.Label;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import minigames.clik_or_crit.data.Gear;
	import minigames.clik_or_crit.data.GearItem;
	import minigames.clik_or_crit.data.GearSlot;

	public class GearItemView extends Sprite 
	{
		public static const titleLocation:Point = new Point(200, 140);
		public static const levelLocation:Point = new Point(200, 160);
		public static const statLabelLocations:Vector.<Point> = new <Point>[new Point(0, 205), new Point(0, 130), new Point(0, 55), new Point(0, 280)];
		
		
		public var item:GearItem;
		private var img:Bitmap;
		private var dimX:int;
		private var dimY:int;
		private var titleL:Label;
		private var levelLabel:Label;
		private var availableStatus:Boolean;
		private var mainView:CCView;
		private var gear:Gear;
		private var labels:Vector.<Label>;
		
		public function GearItemView() 
		{
			img = new Bitmap();
			addChild(img);
			
			titleL = new Label(Label.CENTER_Align);
			titleL.x = titleLocation.x;
			titleL.y = titleLocation.y;
			addChild(titleL);
			
			levelLabel = new Label(Label.CENTER_Align, dimX, dimY - 5);
			levelLabel.x = levelLocation.x;
			levelLabel.text = S.format.edge(15) + "0";
			levelLabel.y = levelLocation.y;
			addChild(levelLabel);
		}
		
		public function load(item:GearItem, gear:Gear, mainView:CCView):void 
		{
			this.gear = gear;
			this.mainView = mainView;
			this.item = item;
			
			titleL.text = S.format.edge(15) + item.name;
			levelLabel.text = S.format.edge(15) + item.level;
			
			
			availableStatus = gear.canUpgrade();
			
			if (item.stats.length == 0)
				img.bitmapData = null;/*
			else if (item.stats.length == 1)
				img.bitmapData = S.pics.clickOrCrit.gearViewItem.;
			else if (item.stats.length == 2)
				img.bitmapData = S.pics.clickOrCrit.gearViewItem.;
			else if (item.stats.length == 3)
				img.bitmapData = S.pics.clickOrCrit.gearViewItem.;
			else if (item.stats.length == 4)
				img.bitmapData = S.pics.clickOrCrit.gearViewItem.;*/
			
			labels = new Vector.<Label>();
			for (var i:int = 0; i < item.stats.length; i++) 
			{
				var statLabel:Label = new Label();
				addChild(statLabel);
				labels.push(statLabel);
				statLabel.x = statLabelLocations[i].x;
				statLabel.y = statLabelLocations[i].y;
				//statLabel.text = item.stats[i].attribute + " " + item.stats[i].getValue(item.level);
			}
			onLevelChanged();
		}
		
		public function onLevelChanged():void 
		{
			for (var i:int = 0; i < item.stats.length; i++) 
			{
				labels[i].text = S.format.edge(12) + item.stats[i].attribute + " " + (item.stats[i].getValue(item.level) * 100).toFixed() + "%";
			}
			levelLabel.text = S.format.main(12) + item.level;
		}
		
		public function update(timePassed:int):void
		{/*
			if (!item)
				return;
			var isAvailable:Boolean = slot.isItemAvailable(item);
			if (isAvailable != availableStatus)
			{
				availableStatus = isAvailable;
				if (availableStatus)
					img.bitmapData = S.pics.clickOrCrit.gearViewItem.normal;
				else
					img.bitmapData = S.pics.clickOrCrit.gearViewItem.disabled;
			}*/
		}
		
		public function clear():void 
		{
			item = null;
			gear = null;
			img.bitmapData = null;
			if (parent)
				parent.removeChild(this);
		}
		
	}

}