package minigames.clik_or_crit.data 
{

	public class GearItem 
	{
		public var stats:Vector.<GearStat>;
		public var name:String;
		public var level:int;
		
		public function GearItem() 
		{
			
		}
		
		public function apply(hero:Hero):void
		{
			for (var i:int = 0; i < stats.length; i++) 
			{
				stats[i].apply(hero, level);
			}
		}
		
		public function clear(hero:Hero):void
		{
			for (var i:int = 0; i < stats.length; i++) 
			{
				stats[i].clear(hero);
			}
		}
		
		public function load(source:Object):void 
		{
			name = source.name;
			stats = new Vector.<GearStat>();
			for (var i:int = 0; i < source.stats.length; i++) 
			{
				var stat:GearStat = new GearStat();
				stat.load(source.stats[i]);
				stats.push(stat);
			}
		}
	}

}