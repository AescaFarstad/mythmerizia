package minigames.clik_or_crit.view 
{
	import components.Label;
	import flash.display.Sprite;
	import minigames.clik_or_crit.data.Attribute;
	import minigames.clik_or_crit.data.Hero;
	
	

	public class HeroStatsPanel extends Sprite 
	{
		private var hero:Hero;
		private var titleL:Label;
		private var hpL:Label;
		private var damageL:Label;
		private var attackSpeedL:Label;
		private var critChanceL:Label;
		private var critDamageL:Label;
		
		private var attributesTitleL:Label;
		private var attributeLabels:Vector.<Label>;
		private var attributes:Vector.<String>;
		
		public function HeroStatsPanel() 
		{
			super();
			
			var dx:Number = 5;
			var dy:int = 10;
			
			titleL = new Label();
			addChild(titleL);
			titleL.x = dx;
			titleL.y = dy;
			dy += 30;
			
			hpL = new Label();
			addChild(hpL);
			hpL.x = dx;
			hpL.y = dy;	
			dy += 15;
			
			damageL = new Label();
			addChild(damageL);
			damageL.x = dx;
			damageL.y = dy;	
			dy += 15;
			
			attackSpeedL = new Label();
			addChild(attackSpeedL);
			attackSpeedL.x = dx;
			attackSpeedL.y = dy;	
			dy += 30;
			
			critChanceL = new Label();
			addChild(critChanceL);
			critChanceL.x = dx;
			critChanceL.y = dy;	
			dy += 15
			
			critDamageL = new Label();
			addChild(critDamageL);
			critDamageL.x = dx;
			critDamageL.y = dy;	
			dy += 30;
			
			attributesTitleL = new Label();
			addChild(attributesTitleL);
			attributesTitleL.x = dx;
			attributesTitleL.y = dy;
			attributesTitleL.text = S.format.edge(15) + "Attributes:"
			dy += 20;
			
			attributeLabels = new Vector.<Label>();
			attributes = new < String > ["strength", "constitution", "willpower", "agility", 
															"cunning", "intelect"];
			for (var i:int = 0; i < attributes.length; i++) 
			{
				var label:Label = new Label();
				addChild(label);
				label.x = dx;
				label.y = dy;
				dy += 15;
				attributeLabels.push(label);
			}
			
			graphics.lineStyle(2, 0xbbbbbb);
			graphics.beginFill(0xdddddd);
			graphics.drawRect(0, 0, 200, dy);
			graphics.endFill();
		}
		
		public function load(hero:Hero):void
		{
			this.hero = hero;
			updateLabels();
		}
		
		public function update(timePassed:int):void
		{
			if (!hero || !hero.isAlive)
			{
				visible = false;
				return;
			}
			if (hero)
				updateLabels();
		}
		
		
		private function updateLabels():void 
		{
			titleL.text = S.format.edge(15) + hero.name;
			hpL.text = S.format.edge(12) + "HP: " + hero.hp.value.toFixed() + " / " + hero.hp.maxValue.toFixed() + " (+" + hero.hp.regen.toFixed() + " / sec.)";
			damageL.text = S.format.edge(12) + "Damage: "+ hero.damage.value.toFixed();
			attackSpeedL.text = S.format.edge(12) + "Attack speed: "+ hero.attackSpeed.value.toFixed();
			critChanceL.text = S.format.edge(12) + "Crit chance: " + (hero.critChance.value * 100).toFixed() + "%";
			critDamageL.text = S.format.edge(12) + "Crit Damage: " + (hero.critDamage.value * 100).toFixed() + "%";
			
			for (var i:int = 0; i < attributeLabels.length; i++) 
			{
				var attribute:Attribute = hero[attributes[i]] as Attribute;
				attributeLabels[i].text = S.format.edge(10) + "\t" + attribute.name + ": " + attribute.value.toFixed();
			}
		}
		
	}

}