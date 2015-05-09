package engine 
{
	public class LinkedListNode 
	{
		public var nextNode:LinkedListNode;
		public var prevNode:LinkedListNode;
		public var value:*;
		
		public function LinkedListNode(value:*)
		{
			this.value = value;
		}
		
		public function clear():void
		{
			nextNode = null;
			prevNode = null;
		}
	}
}