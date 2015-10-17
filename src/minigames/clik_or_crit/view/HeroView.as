package minigames.clik_or_crit.view 
{
	import components.Label;
	import flash.display.Sprite;
	import minigames.clik_or_crit.data.Hero;
	import minigames.clik_or_crit.data.IHeroListener;
	import minigames.clik_or_crit.view.ProgressBar;
	
	

	public class HeroView extends Sprite implements IHeroListener
	{
		public var hero:Hero;
		private var label:Label;
		private var healthBar:ProgressBar;
		
		private var maxHealthCache:Number;
		private var healthCache:Number;
		private var mainView:CCView;
		private var damageIndicator:DamageIndicator;
		
		public function load(hero:Hero, mainView:CCView):void 
		{
			this.mainView = mainView;
			this.hero = hero;
			hero.listener = this;
			x = hero.location.x * CCView.SCALE;
			y = hero.location.y * CCView.SCALE;
			
			render();
			
			damageIndicator = new DamageIndicator();
			addChild(damageIndicator);
			
			label = new Label(Label.CENTER_Align);
			label.text = S.format.white(12) + hero.name;
			addChild(label);
			
			healthBar = new ProgressBar(35, 6, hero.hp.maxValue, 0);
			healthBar.setStyle(0xffffdd, 0x444444, 0xff8888, 1);
			maxHealthCache = hero.hp.maxValue;
			healthCache = hero.hp.value;
			healthBar.setValue(healthCache);
			addChild(healthBar);
			healthBar.x -= healthBar.width / 2;
			healthBar.y = -20;
		}
		
		public function update(timePassed:int):void
		{
			x = hero.location.x * CCView.SCALE;
			y = hero.location.y * CCView.SCALE;
			
			if (hero.hp.maxValue != maxHealthCache)
			{
				maxHealthCache = hero.hp.maxValue;
				healthBar.maxValue = maxHealthCache;
				healthBar.update();
			}
			if (hero.hp.value != healthCache)
			{
				healthCache = hero.hp.value;
				healthBar.setValue(healthCache);
			}
			damageIndicator.update(timePassed);
		}
		
		private function render():void
		{
			graphics.clear();
			var color:uint = hero.party.isPlayer ? 0x88bbff : 0xaa55ff;
			graphics.lineStyle(1, 0, 0);
			graphics.beginFill(color, 1);
			graphics.drawCircle(0, 0, Hero.SIZE * CCView.SCALE);
			graphics.endFill();	
			alpha = hero.isAlive ? 1 : 0.1;
		}
		
		public function onDeath():void
		{
			render();
			healthBar.visible = false;
		}
			
		public function onDamaged(damage:Number, from:Hero, isCrit:Boolean):void 
		{
			mainView.animUpdater.push(DamageLabel.show(mainView.field, damage, from, hero, isCrit, false));
			damageIndicator.impulse();
		}
		
		public function healed(value:Number):void 
		{
			mainView.animUpdater.push(DamageLabel.show(mainView.field, value, null, hero, false, true));
			//damageIndicator.impulse();
		}
		
		public function cleanup():void 
		{
			hero.listener = null;
			if (parent)
				parent.removeChild(this);			
		}
		
	}

}