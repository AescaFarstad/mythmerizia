package minigames.clik_or_crit.data 
{
	import flash.geom.Point;
	
	public interface ICCListener 
	{
		function onHeroAdded(hero:Hero):void;
		function onHeroDied(hero:Hero):void;
		
		function onZoneChanged():void;
		
		function onGoldDrop(location:Point, amount:Number, dropDelay:int):void;
	}
	
}