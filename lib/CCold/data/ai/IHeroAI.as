package minigames.clik_or_crit.data.ai 
{
	import minigames.clik_or_crit.data.ability.AbilityData;
	import minigames.clik_or_crit.data.Hero;
	public interface IHeroAI 
	{
		function act(timePassed:int):void;
		
		function getHeroTarget(ability:AbilityData):Hero;
		
		function interrupt():void;
	}
	
}