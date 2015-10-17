package minigames.clik_or_crit 
{
	import minigames.clik_or_crit.data.Hero;
	
	public interface IInputListener 
	{
		function onHeroCLick(hero:Hero):void;
		
		function onNextZone():void;
		function onPrevZone():void;
	}
	
}