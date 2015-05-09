package engine 
{	
	public class AnimUpdater 
	{
		private var _list:LinkedList;
		private var _nextNode:LinkedListNode;
		
		public function AnimUpdater() 
		{
			_list = new LinkedList();
		}
		
		public function push(animation:IAnimUpdatable):void
		{
			if (!animation.isPlugedIn)
			{
				_list.push(animation.getNode());
				animation.isPlugedIn = true;
				animation.updater = this;
			}
			else
			{
				throw new Error("Animation is already pluged in.");
			}
		}
		
		public function remove(animation:IAnimUpdatable):void
		{
			if (animation != null && animation.isPlugedIn)
			{
				if (_nextNode && _nextNode.value == animation)
				{					
					_nextNode = animation.getNode().nextNode;
				}
				_list.remove(animation.getNode());
				animation.isPlugedIn = false;
				animation.updater = null;
			}
			else
			{
				throw new Error("Animation is not pluged in.");
			}
		}
		
		public function update(timePassed:int):void
		{
			var node:LinkedListNode = _list.firstNode;
			while (node)
			{	
				var animation:IAnimUpdatable = node.value;
				_nextNode = node.nextNode;
				animation.update(timePassed);
				if (animation.isComplete() && animation.isPlugedIn)
				{				
					_list.remove(node);
					animation.isPlugedIn = false;					
					animation.updater = null;
				}
				node = _nextNode;
			}
			_nextNode = null;
		}
		
		public function forceComplete():void
		{
			var node:LinkedListNode = _list.firstNode;
			while (node)
			{	
				var animation:IAnimUpdatable = node.value;
				_nextNode = node.nextNode;
				animation.forceComplete();
				if (animation.isPlugedIn)
				{
					_list.remove(node);
					animation.isPlugedIn = false;					
					animation.updater = null;
				}
				node = _nextNode;
			}
		}
		
		public function get isEmpty():Boolean 
		{
			return _list.length == 0;
		}
		
		public function hasAnimation(animation:IAnimUpdatable):Boolean
		{
			var node:LinkedListNode = _list.firstNode;
			if (_nextNode == animation)
				return true;
			while (node)
			{	
				if (node.value == animation)
					return true;
				node = node.nextNode;
			}
			return false;
		}
	}
}