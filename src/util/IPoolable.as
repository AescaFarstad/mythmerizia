package util 
{
	
	public interface IPoolable 
	{
		function setPool(pool:SimplePool):void;
		function clearForPool():void;
		function pushToPool():*;
	}
	
}