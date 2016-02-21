package minigames.rabbitHole 
{
	
	public interface ISaveLoadable 
	{
		function saveToObject(verbose:Boolean = false):Object;
		
		function loadFromObject(save:Object):void;
		
		function get id():int;
	}
	
}