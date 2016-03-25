package minigames.clik_or_crit.view 
{
	import components.Label;
	import engine.IAnimUpdatable;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import util.HMath;
	import util.SimplePool;

	public class DropLabel extends BaseAnimation
	{
		private static const POOL:SimplePool = new SimplePool(DropLabel);
		
		private static const DURATION:int = 1200;
		private static const SPEED:Number = 0.05;
		
		private var label:Label;
		
		public static function show(parent:DisplayObjectContainer, amount:Number, locations:Point):DropLabel
		{
			var dropLabel:DropLabel = POOL.pop();
			parent.addChild(dropLabel);
			dropLabel.load(amount, locations);
			return dropLabel;
		}
		
		public function load(amount:Number, location:Point):void 
		{
			label.text = (S.format.gold(30) + amount.toFixed());
			
			_duration = DURATION;
			
			label.x = location.x * CCView.SCALE - label.width/2 + (Math.random() - 0.5) * 60;
			label.y = location.y * CCView.SCALE + (Math.random() - 0.5) * 60;
		}
		
		public function DropLabel() 
		{
			mouseChildren = mouseEnabled = false;
			label = new Label();
			addChild(label);
		}
		
		override public function update(timePassed:int):void 
		{
			_time += timePassed;
			label.y -= timePassed * SPEED;
			
			label.alpha = HMath.nonlinearInterp(0, 1, _duration, 0, 5, _time);
			
			if (isComplete())
				cleanup();
		}
		
		private function cleanup():void 
		{
			if (parent)
				parent.removeChild(this);
			if (isPlugedIn)
				_updater.remove(this);
			POOL.push(this);
			_time = 0;
			//label.alpha = 1;
		}
		
	}

}