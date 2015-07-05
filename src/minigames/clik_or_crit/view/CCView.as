package minigames.clik_or_crit.view 
{
	import engine.AnimUpdater;
	import flash.display.Sprite;
	import minigames.clik_or_crit.data.CCModel;
	import minigames.clik_or_crit.data.Hero;
	import minigames.clik_or_crit.data.ICCListener;
	import minigames.clik_or_crit.view.HeroView;
	
	

	public class CCView extends Sprite implements ICCListener
	{
		public static const SCALE:Number = 600;
		
		private var heroViews:Vector.<HeroView> = new Vector.<HeroView>();
		public var animUpdater:AnimUpdater;
		private var zoneView:ZoneView;
		
		public function CCView() 
		{
			animUpdater = new AnimUpdater();
			zoneView = new ZoneView();
			addChild(zoneView);			
		}
		
		public function load(model:CCModel):void 
		{
			model.listener = this;
			for (var i:int = 0; i < model.parties.length; i++) 
			{
				for (var j:int = 0; j < model.parties[i].heroes.length; j++) 
				{
					var view:HeroView = new HeroView();
					addChild(view);
					view.load(model.parties[i].heroes[j], this);
					heroViews.push(view);
				}
			}
			zoneView.load(model.currentZone);
		}
		
		public function update(timePassed:int):void
		{
			animUpdater.update(timePassed);
			for (var i:int = 0; i < heroViews.length; i++) 
			{
				heroViews[i].update(timePassed);
			}
		}
		
		public function onHeroAdded(hero:Hero):void
		{
			var view:HeroView = new HeroView();
			addChild(view);
			view.load(hero, this);
			heroViews.push(view);
		}
		
		
	}

}