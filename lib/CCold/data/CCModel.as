package minigames.clik_or_crit.data 
{
	import engine.TimeLineManager;
	import flash.geom.Point;

	public class CCModel 
	{
		private static var DROP_DELAY:int = 0;
		[Embed(source = "../../../../lib/click or crit/data.json", mimeType = "application/octet-stream")]
		private static var dataSource:Class;
		
		[Embed(source = "../../../../lib/click or crit/playerHeroes.json", mimeType = "application/octet-stream")]
		private static var playerHeroesSource:Class;
		
		[Embed(source = "../../../../lib/click or crit/creatures.json", mimeType = "application/octet-stream")]
		private static var creaturesSource:Class;		
		
		[Embed(source = "../../../../lib/click or crit/gear.json", mimeType = "application/octet-stream")]
		private static var gearSourceClass:Class;
		
		public var playerParty:Party;
		public var animalParty:Party;
		
		private var source:Object;
		private var gearSource:Object;
		public var isComplete:Boolean;
		
		private var updateCounter:int;
		private var additionalTime:int = 1500;
		
		public var parties:Vector.<Party> = new Vector.<Party>();
		public var world:World;
		public var listener:ICCListener;
		public var divine:Divine;
		public var timeline:TimeLineManager;
		
		public function CCModel() 
		{
			timeline = new TimeLineManager();
			
			source = JSON.parse(new dataSource());
			gearSource = JSON.parse(new gearSourceClass());
			playerParty = new Party(this);
			animalParty = new Party(this);
			
			playerParty.load(source.playerParty, animalParty);
			animalParty.load(source.animalParty, playerParty);
			playerParty.isPlayer = true;
			
			parties.push(playerParty);
			parties.push(animalParty);
			
			var playerPrototypes:HeroPrototypeCollection = new HeroPrototypeCollection(playerHeroesSource);
			playerPrototypes.loadAll(playerParty);
			
			
			var animalPrototypes:HeroPrototypeCollection = new HeroPrototypeCollection(creaturesSource);
			world = new World(animalPrototypes);			
			world.currentZone.spawnNext(animalParty);
			
			divine = new Divine();
		}
		
		public function update(timePassed:int):void
		{
			updateCounter++;
			timeline.update(timePassed);
			playerParty.update(timePassed);	
			animalParty.update(timePassed);
			if (!playerParty.isAlive)
			{
				if (additionalTime < 0)
				{
					isComplete = true;
					return;
				}
				else
				{
					additionalTime-= timePassed;
					if (additionalTime < 0)
						trace("ANIMALS WON");
				}
			}			
		}
		
		public function onHeroDied(party:Party, hero:Hero):void 
		{
			if (!party.isPlayer)
			{
				world.currentZone.spawnNext(animalParty);
				if (!animalParty.isAlive)
				{
					goToNextZone();
				}
			}
			if (listener)
				listener.onHeroDied(hero);
			if (!isNaN(hero.goldDrop))
			{
				timeline.add(DROP_DELAY, addGold, [hero.goldDrop], "drop gold");
				if (listener)
					listener.onGoldDrop(hero.location, hero.goldDrop, DROP_DELAY);				
			}	
			
			function addGold(amount:Number):void
			{
				divine.gold.value += hero.goldDrop;
			}
		}
		
		public function onHeroAdded(hero:Hero):void 
		{
			if (listener)
				listener.onHeroAdded(hero);
		}
		
		public function onHeroClick(hero:Hero):void
		{
			if (hero.party.isPlayer)
				hero.heal(divine.heal.value);
			else
				hero.takeHit(divine.damage.value, null, false);
		}
		
		public function goToNextZone():void 
		{
			world.goToNextZone();
			restartForNewZone();
		}
		
		public function goToPrevZone():void 
		{
			world.goToPrevZone();
			restartForNewZone();
		}
		
		public function getGearSource(name:String):Object 
		{
			return gearSource[name];
		}
		
		private function restartForNewZone():void 
		{
			for (var i:int = 0; i < parties.length; i++) 
			{
				parties[i].interrupt();
			}
			if (listener)
				listener.onZoneChanged();
			animalParty.clearAfterZone();
			world.currentZone.restart();
			world.currentZone.spawnNext(animalParty);
		}
		
	}

}