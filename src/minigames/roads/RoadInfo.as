package minigames.roads 
{
	import components.Label;
	import flash.display.Sprite;
	import util.Button;
	import util.layout.LayoutGroup;
	import util.layout.LayoutUtil;
	
	public class RoadInfo extends Sprite
	{
		private var road:Road;
		private var group:LayoutGroup;
		private var model:RoadsModel;
		private var upCapacity:Button;
		private var upMaxSpeed:Button;
		private var buttonGroup:LayoutGroup;
		private var capacity:Label = new Label();
		private var maxSpeed:Label = new Label();
		private var currentSpeed:Label = new Label();
		
		public function RoadInfo()
		{
			super();
			group = new LayoutGroup(capacity, maxSpeed, currentSpeed);
			addChild(capacity);
			addChild(maxSpeed);
			addChild(currentSpeed);
			
			upCapacity = new Button("Up capacity", onUpgradeCapacity);
			addChild(upCapacity);
			upMaxSpeed = new Button("Up speed", onUpgradeSpeed);
			addChild(upMaxSpeed);
			
			buttonGroup = new LayoutGroup(upCapacity, upMaxSpeed);
			visible = false;
		}
		
		private function onUpgradeSpeed(e:*):void
		{
			model.upgradeSpeed(road);
		}
		
		private function onUpgradeCapacity(e:*):void
		{
			model.upgradeCapacity(road);			
		}
		
		public function load(road:Road, model:RoadsModel):void
		{
			
			this.model = model;
			this.road = road;
			
			if (!road)
			{		
				visible = false;
				return;
			}
			else
				visible = true;
			capacity.text = S.format.black(16) + "Capacity: " + road.getResultingCapacity().toFixed(1);
			maxSpeed.text = S.format.black(16) + "Max Speed: " + (road.maxVelocity * 100).toFixed();
			currentSpeed.text = S.format.black(16) + "Speed: " + (road.getSpeed() * 100).toFixed();
			
			group.arrangeInVerticalLineWithSpacing(4);
			buttonGroup.arrangeInHorizontalLineWithSpacing(10);
			LayoutUtil.moveAtBottom(buttonGroup, group, 10);
			
			var tmp:LayoutGroup = new LayoutGroup(group, buttonGroup);
			
			var padding:int = 5;
			graphics.beginFill(0xe7e7e7);
			graphics.drawRoundRect( -padding, -padding, tmp.baseWidth + padding * 2, tmp.baseHeight + padding * 2, 10, 10);
			graphics.endFill();
		}
		
		public function update():void
		{
			if (!road)
				return;
			capacity.text = S.format.black(16) + "Capacity: " + road.getResultingCapacity().toFixed(1);
			maxSpeed.text = S.format.black(16) + "Max Speed: " + (road.maxVelocity * 100 * 100).toFixed();
			currentSpeed.text = S.format.black(16) + "Speed: " + (road.getSpeed() * 100 * 100).toFixed();
			upCapacity.text = "Up capacity (" + model.getUpCapacityPrice(road) + ")";
			upMaxSpeed.text = "Up speed (" + model.getUpSpeedPrice(road) + ")";
		}
		
	}
}