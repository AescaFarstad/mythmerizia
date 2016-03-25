package minigames.clik_or_crit.data 
{
	
	public interface IHeroListener 
	{
		function onDeath():void;
		function onDamaged(damage:Number, from:Hero, isCrit:Boolean):void;
		
		function healed(value:Number):void;
		
	}
	
}