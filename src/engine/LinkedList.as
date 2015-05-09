package engine 
{
	public final class LinkedList 
	{
		public var firstNode:LinkedListNode;
		public var lastNode:LinkedListNode;
		private var _length:int;
		
		public function LinkedList() 
		{
		}
		
		public function push(node:LinkedListNode):void
		{
			if (lastNode)
			{
				lastNode.nextNode = node;
				node.prevNode = lastNode;
			}
			else
			{
				firstNode = node;
			}
			lastNode = node;
			_length ++;
		}
		
		public function remove(node:LinkedListNode):void
		{
			if (node.prevNode)
				node.prevNode.nextNode = node.nextNode;
			else
				firstNode = node.nextNode;
			if (node.nextNode)
				node.nextNode.prevNode = node.prevNode;
			else
				lastNode = node.prevNode;
			node.prevNode = null;
			node.nextNode = null;
			_length --;
		}
		
		//debug
		private function exists(test:LinkedListNode):Boolean 
		{
			var node:LinkedListNode = firstNode;
			while (node)
			{
				if (test == node)
					return true;
				node = node.nextNode;
			}
			return false;
		}
		
		public function clear():void
		{
			var node:LinkedListNode = firstNode;
			while (node)
			{
				var nextNode:LinkedListNode = node.nextNode;
				node.clear();
				node = nextNode;
			}
			firstNode = null;
			lastNode = null;
			_length = 0;
		}
		
		public function get length():int
		{
			return _length;
		}
	}
}