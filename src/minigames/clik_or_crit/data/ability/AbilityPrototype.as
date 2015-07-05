package minigames.clik_or_crit.data.ability 
{

	public class AbilityPrototype 
	{
		public var targetingAlgorithm:AbilityTargetAlgorithm;
		public var name:String;
		public var type:AbilityType;
		public var minRange:Number;
		public var cooldown:Number;
		public var targetType:AbilityTargetType;
		public var isAffectedByAttackSpeed:Boolean;
		public var isAffectedByAttackCrits:Boolean;
		
		public var getTarget:Function;
		public var exec:Function;
		
		public function AbilityPrototype(name:String, type:AbilityType, targetType:AbilityTargetType, targetingAlgorithm:AbilityTargetAlgorithm) 
		{
			this.targetingAlgorithm = targetingAlgorithm;
			this.targetType = targetType;
			this.type = type;
			this.name = name;			
		}
		
	}

}