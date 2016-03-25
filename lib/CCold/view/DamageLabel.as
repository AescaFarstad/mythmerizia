package minigames.clik_or_crit.view 
{
	import components.Label;
	import engine.LinkedListNode;
	import engine.AnimUpdater;
	import engine.IAnimUpdatable;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import minigames.clik_or_crit.data.Hero;
	import util.HMath;
	import util.IPoolable;
	import util.SimplePool;

	public class DamageLabel extends BaseAnimation
	{
		private static const POOL:SimplePool = new SimplePool(DamageLabel);
		
		private static const DURATION:int = 1000;
		private static const SPEED:Number = 0.1;
		
		private var label:Label;
		
		public function DamageLabel() 
		{
			mouseChildren = mouseEnabled = false;
			label = new Label();
			addChild(label);
		}
		
		public static function show(parent:DisplayObjectContainer, damage:Number, from:Hero, to:Hero, isCrit:Boolean, isHeal:Boolean):DamageLabel
		{
			var dmgLabel:DamageLabel = POOL.pop();
			parent.addChild(dmgLabel);
			dmgLabel.load(damage, from, to, isCrit, isHeal);
			return dmgLabel;
		}
		
		public function load(damage:Number, from:Hero, to:Hero, isCrit:Boolean, isHeal:Boolean):void
		{
			var format:String;
			if (to.party.isPlayer)
			{
				format = isHeal ? S.format.main(30) : S.format.blood(30);
			}
			else
			{
				format = S.format.edge(30);
			}
			label.text = format + damage.toFixed() + (isCrit ? "!" : "");
			_duration = DURATION;
			label.x = to.location.x * CCView.SCALE - label.width/2 + (Math.random() - 0.5) * 60;
			label.y = to.location.y * CCView.SCALE + (Math.random() - 0.5) * 60;
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