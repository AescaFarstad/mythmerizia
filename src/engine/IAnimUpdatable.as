package engine 
{
	
	public interface IAnimUpdatable 
	{
		function update(timePassed:int):void;
		
		function isComplete():Boolean;
		
		function getNode():LinkedListNode;
		
		function forceComplete():void;
		
		function set isPlugedIn(value:Boolean):void;
		
		function get isPlugedIn():Boolean;
		
		function set updater(value:AnimUpdater):void;
	}
	
}