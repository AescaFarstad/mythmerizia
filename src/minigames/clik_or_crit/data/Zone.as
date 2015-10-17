package minigames.clik_or_crit.data 
{
	import util.RMath;
	
	public class Zone 
	{
		private var animals:Vector.<HeroPrototype>;
		public var packs:Vector.<Vector.<HeroPrototype>>;
		private var animalPrototypes:HeroPrototypeCollection;
		private var difficulty:int;
		private var world:World;
		public var index:int;
		public var name:String;
		public var currentIndex:int;
		public var listener:IZoneListener;
		public var isPassed:Boolean;
		
		public function Zone(animalPrototypes:HeroPrototypeCollection, name:String, index:int, difficulty:int, world:World) 
		{
			this.world = world;
			this.index = index;
			this.difficulty = difficulty;
			this.name = name;
			this.animalPrototypes = animalPrototypes;
			restart();
		}
		
		public function restart():void
		{
			currentIndex = 0;
			
			var totalSpawned:int = 0;
			var currentCount:int = 0;
			var optimalCount:int = 4;
			
			var options:Array = [
			{weight:1, value:2 },
			{weight:3, value:3 },
			{weight:5, value:4 },
			{weight:3, value:5 },
			{weight:1, value:6 }			
			];
			packs = new Vector.<Vector.<HeroPrototype>>();
			var counts:Vector.<int> = new Vector.<int>();
			while(totalSpawned < 10)
			{
				var next:int = RMath.getWeightedItem(options);
				counts.push(next);
				totalSpawned += next;
			}
			
			var current:int = 0;
			for (var i:int = 0; i < counts.length; i++) 
			{
				if (current < counts[i])
				{
					var pack:Vector.<HeroPrototype> = new Vector.<HeroPrototype>();
					while (current < counts[i])
					{
						pack.push(RMath.getItem(animalPrototypes.vec));
						current++;
					}
					packs.push(pack);
				}
				else
				{
					while (current >= counts[i])
					{
						packs.push(null);
						current--;
					}
					current++;
				}
				current--;
			}			
			if (listener)
				listener.onRestart();
		}
		
		public function spawnNext(animalParty:Party):Boolean 
		{
			if (packs.length <= currentIndex)
			{
				var wasPassed:Boolean = isPassed;
				isPassed = true;
				if (wasPassed != isPassed)
					world.onZonePassed();
				return false;
			}
			if (!packs[currentIndex])
			{
				currentIndex++;	
			}
			else
			{			
				animalPrototypes.loadPack(animalParty, packs[currentIndex], setDifficulty);
				currentIndex++;
			}
			
			if (listener)
				listener.onProgress();
			return true;
		}
		
		private function setDifficulty(hero:Hero):void
		{
			var constMain:Object = { constitution:0.8, strength:0.2 };
			var strength:Object = { constitution:0.5, strength:0.5 };
			var balance:Object = { constitution:0.3, agility:0.3, strength:0.3, cunning:0.1 };
			
			var options:Array = [ { weight:3, value:constMain }, { weight:2, value:strength }, { weight:5, value:balance } ];
			var result:Object = RMath.getWeightedItem(options);
			for (var key:String in result)
			{
				hero[key].modify("zone difficulty", result[key] * difficulty, 0);
			}
			hero.replenish();
			hero.goldDrop = hero.baseGoldDrop * Math.pow( 1.1, difficulty); 
		}
	}
}