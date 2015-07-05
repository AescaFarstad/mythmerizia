package minigames.clik_or_crit.data 
{
	import util.RMath;
	
	public class Zone 
	{
		
		
		private var source:Object;
		private var animals:Vector.<HeroPrototype>;
		public var packs:Vector.<Vector.<HeroPrototype>>;
		private var animalPrototypes:HeroPrototypeCollection;
		public var currentIndex:int;
		public var listener:IZoneListener;
		
		
		public function Zone(animalPrototypes:HeroPrototypeCollection) 
		{
			this.animalPrototypes = animalPrototypes;
			
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
			while(totalSpawned < 20)
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
		}
		
		public function spawnNext(animalParty:Party):Boolean 
		{
			trace("spawn Next");
			if (packs.length <= currentIndex)
				return false;
			if (!packs[currentIndex])
			{
				currentIndex++;	
			}
			else
			{			
				animalPrototypes.loadPack(animalParty, packs[currentIndex]);
				currentIndex++;
			}
			
			if (listener)
				listener.onProgress();
			return true;
		}
		
		
		
	}

}