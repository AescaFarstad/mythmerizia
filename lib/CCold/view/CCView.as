package minigames.clik_or_crit.view 
{
	import components.HintManager;
	import engine.AnimUpdater;
	import engine.TimeLineManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import minigames.clik_or_crit.data.CCModel;
	import minigames.clik_or_crit.data.Hero;
	import minigames.clik_or_crit.data.ICCListener;
	import minigames.clik_or_crit.IInputListener;
	import minigames.clik_or_crit.view.HeroView;
	
	

	public class CCView extends Sprite implements ICCListener
	{
		public static const SCALE:Number = 600;
		
		private var heroViews:Vector.<HeroView> = new Vector.<HeroView>();
		private var viewByHero:Dictionary = new Dictionary();
		public var animUpdater:AnimUpdater;
		public var inputListener:IInputListener;
		private var zoneView:ZoneView;
		private var heroStatsPanel:HeroStatsPanel;
		private var heroGearPanel:GearPanel;
		private var model:CCModel;
		private var navPanel:NavPanel;
		public var timeline:TimeLineManager;
		public var resourcePanel:ResourcePanel;
		public var field:Sprite;
		private var selectedHero:Hero;
		public var hintManager:HintManager;
		
		
		public function CCView() 
		{
			hintManager = new HintManager();
			
			
			field = new Sprite();
			addChild(field);
			field.x = 100;
			timeline = new TimeLineManager();
			animUpdater = new AnimUpdater();
			zoneView = new ZoneView();
			addChild(zoneView);
			heroStatsPanel = new HeroStatsPanel();
			heroStatsPanel.visible = false;
			addChild(heroStatsPanel);
			navPanel = new NavPanel();
			addChild(navPanel);
			
			resourcePanel = new ResourcePanel();
			addChild(resourcePanel);
			
			heroGearPanel = new GearPanel();
			addChild(heroGearPanel);
			heroGearPanel.visible = false;
			
			var hintSprite:Sprite = new Sprite();
			hintSprite.name = "hint layer";
			hintSprite.mouseChildren = hintSprite.mouseEnabled = false;
			addChild(hintSprite);
			hintManager.init(hintSprite, new Rectangle(0, 0, 1000, 800));
		}
		
		public function load(model:CCModel):void 
		{
			this.model = model;
			model.listener = this;
			for (var i:int = 0; i < model.parties.length; i++) 
			{
				for (var j:int = 0; j < model.parties[i].heroes.length; j++) 
				{
					onHeroAdded(model.parties[i].heroes[j]);
				}
			}
			zoneView.load(model.world.currentZone);
			navPanel.load(model.world, this);
			navPanel.x = 1000 - navPanel.width;
			
			resourcePanel.load(model);
			resourcePanel.y = zoneView.height;
		}
		
		public function update(timePassed:int):void
		{
			timeline.update(timePassed);
			animUpdater.update(timePassed);
			for (var i:int = 0; i < heroViews.length; i++) 
			{
				heroViews[i].update(timePassed);
			}
			if (heroStatsPanel.visible)
				heroStatsPanel.update(timePassed);
			if (heroGearPanel.visible)
				heroGearPanel.update(timePassed);
			resourcePanel.update(timePassed);
		}
		
		public function onHeroAdded(hero:Hero):void
		{
			var view:HeroView = new HeroView();
			field.addChild(view);			
			view.load(hero, this);
			heroViews.push(view);
			viewByHero[hero] = view;
			view.addEventListener(MouseEvent.MOUSE_DOWN, onHeroClick);
		}
		
		public function onHeroDied(hero:Hero):void
		{
			if (selectedHero == hero)
			{
				heroStatsPanel.visible = false;
				heroGearPanel.visible = false;
				heroGearPanel.clear();
			}
			removeHeroView(hero);
		}
		
		private function onHeroClick(e:MouseEvent):void 
		{
			var view:HeroView = e.currentTarget as HeroView;
			selectHero(view.hero);
			if (inputListener)
				inputListener.onHeroCLick(view.hero);			
		}
		
		private function selectHero(hero:Hero):void
		{
			selectedHero = hero;
			
			heroStatsPanel.load(selectedHero);
			heroStatsPanel.y = 600 - heroStatsPanel.height;
			heroStatsPanel.visible = true;
			
			
			heroGearPanel.clear();
			heroGearPanel.load(selectedHero, this);
			heroGearPanel.y = heroStatsPanel.y;
			heroGearPanel.visible = true;
			heroGearPanel.x = heroStatsPanel.width
		}
		
		public function onZoneChanged():void
		{
			zoneView.load(model.world.currentZone);
			for (var j:int = 0; j < model.animalParty.heroes.length; j++) 
			{
				removeHeroView(model.animalParty.heroes[j]);
			}
		}
		
		private function removeHeroView(hero:Hero):void 
		{
			if (heroViews.indexOf(viewByHero[hero]) != -1)
				heroViews.splice(heroViews.indexOf(viewByHero[hero]), 1);
			if (viewByHero[hero])
			{
				viewByHero[hero].cleanup();
				viewByHero[hero].removeEventListener(MouseEvent.MOUSE_DOWN, onHeroClick);
				delete viewByHero[hero];
			}
		}
		
		public function onGoldDrop(location:Point, amount:Number, delay:int):void 
		{
			animUpdater.push(DropLabel.show(field, amount, location));
		}
		
		
	}

}