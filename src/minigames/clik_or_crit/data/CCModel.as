package minigames.clik_or_crit.data 
{

	public class CCModel 
	{
		[Embed(source = "data.json", mimeType = "application/octet-stream")]
		private static var dataSource:Class;
		
		[Embed(source = "playerHeroes.json", mimeType = "application/octet-stream")]
		private static var playerHeroesSource:Class;
		
		[Embed(source = "creatures.json", mimeType = "application/octet-stream")]
		private static var creaturesSource:Class;
		
		public var playerParty:Party;
		public var animalParty:Party;
		
		private var source:Object;
		public var isComplete:Boolean;
		
		private var updateCounter:int;
		private var additionalTime:int = 1500;
		
		public var parties:Vector.<Party> = new Vector.<Party>();
		public var currentZone:Zone;
		public var listener:ICCListener;
		
		public function CCModel() 
		{
			source = JSON.parse(new dataSource());
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
			currentZone = new Zone(animalPrototypes);
			currentZone.spawnNext(animalParty);
			
		}
		
		public function update(timePassed:int):void
		{
			updateCounter++;
			/*if (updateCounter % 30 == 0)
				trace("Update", updateCounter, "-------------------------------");*/
			timePassed = Math.min(100, timePassed);
			playerParty.update(timePassed);			
			if (!animalParty.isAlive)
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
						trace("PLAYER WON");
				}
			}
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
		
		public function onHeroDied(party:Party):void 
		{
			if (!party.isPlayer)
			{
				if (!currentZone.spawnNext(animalParty))
					isComplete = true;
			}
		}
		
		public function onHeroAdded(hero:Hero):void 
		{
			if (listener)
				listener.onHeroAdded(hero);
		}
		
	}

}