package minigames.clik_or_crit.data 
{
	import util.Global;
	

	public class GearStat 
	{		
		public var ultimateValue:Number;
		public var divider:Number;
		public var attribute:String;
		private var id:int;
		
		public function GearStat() 
		{			
			id = Global.uniqueID;
		}
		
		public function apply(hero:Hero, level:int):void
		{
			(hero[attribute] as Attribute).modify("gearStat" + id, 0, level / divider);
		}
		
		public function clear(hero:Hero):void
		{
			(hero[attribute] as Attribute).removeModifier("gearStat" + id);
		}
		
		public function load(source:Object):void 
		{
			this.ultimateValue = source.ultimateValue;
			this.divider = source.divider;
			this.attribute = source.attribute;
		}
		
		public function getValue(level:int):Number 
		{
			return level / divider;
		}
		
		public function getValueIncrease(level:int):Number 
		{
			return getValue(level + 1) - getValue(level);
		}
	}

}