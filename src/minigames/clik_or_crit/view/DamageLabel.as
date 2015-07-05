package minigames.clik_or_crit.view 
{
	import components.Label;
	import engine.LinkedListNode;
	import engine.AnimUpdater;
	import engine.IAnimUpdatable;
	import flash.display.Sprite;
	import minigames.clik_or_crit.data.Hero;
	import util.HMath;

	public class DamageLabel extends BaseAnimation implements IAnimUpdatable
	{
		private static const DURATION:int = 1000;
		private static const SPEED:Number = 0.1;
		
		private var label:Label;
		
		public function DamageLabel(damage:Number, from:Hero, to:Hero, isCrit:Boolean) 
		{
			label = new Label();
			label.text = S.format.edge(30) + damage.toFixed() + (isCrit ? "!" : "");
			addChild(label);
			
			_duration = DURATION;
			
			label.x = to.location.x * CCView.SCALE - label.width/2;
			label.y = to.location.y * CCView.SCALE;
		}
		
		override public function update(timePassed:int):void 
		{
			_time += timePassed;
			//label.x += timePassed * SPEED;
			label.y -= timePassed * SPEED;
			
			label.alpha = HMath.nonlinearInterp(0, 1, _duration, 0, 5, _time);
			
			if (isComplete())
				cleanup();
		}
		
		private function cleanup():void 
		{
			if (parent)
				parent.removeChild(this);
		}
	}

}