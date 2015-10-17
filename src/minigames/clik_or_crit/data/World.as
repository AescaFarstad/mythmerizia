package minigames.clik_or_crit.data 
{
	

	public class World 
	{
		private var animalPrototypes:HeroPrototypeCollection;
		public var zones:Vector.<Zone>;
		public var currentZone:Zone;
		public var listener:IWorldListener;
		
		public function World(animalPrototypes:HeroPrototypeCollection) 
		{
			this.animalPrototypes = animalPrototypes;
			zones = new Vector.<Zone>();
			for (var i:int = 0; i < 10; i++) 
			{
				addZone(i);				
			}
			currentZone = zones[0];
		}
		
		private function addZone(index:int):void 
		{
			var zone:Zone = new Zone(animalPrototypes, (index + 1).toString(), index, index * 5, this);
			zones.push(zone);
		}
		
		public function goToNextZone():void 
		{
			var currentIndex:int = currentZone.index;
			if (zones.length < currentIndex + 3)
				addZone(zones.length);
			currentZone = zones[currentIndex + 1];
			if (listener)
				listener.onZoneChanged();
		}
		
		public function goToPrevZone():void 
		{
			var currentIndex:int = currentZone.index;
			currentZone = zones[currentIndex - 1];
			if (listener)
				listener.onZoneChanged();
		}
		
		public function onZonePassed():void 
		{
			if (listener)
				listener.onZonePassed();
		}
		
		public function get nextZoneAvailable():Boolean
		{
			return currentZone.isPassed;
		}
		
		public function get prevZoneAvailable():Boolean
		{
			return currentZone.index > 0;
		}
		
		public function get previousZone():Zone
		{
			return zones[currentZone.index - 1];
		}
		
		public function get nextZone():Zone
		{
			return zones[currentZone.index + 1];
		}
	}

}