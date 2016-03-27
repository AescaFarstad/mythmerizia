package engine 
{
	
	public interface IUpdatable 
	{
		function update(timePassed:int):void;
		
		function terminate():void;
	}
	
}