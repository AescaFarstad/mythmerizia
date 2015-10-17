package util 
{
	public final class SimplePool 
	{
		private var _list:Vector.<Object> = new Vector.<Object>;
		private var _listLength:int;
		private var _targetClass:Class;
		private var _balance:int;
		
		public function SimplePool(targetClass:Class) 
		{
			_targetClass = targetClass;
		}
		
		public function pop():*
		{
			_balance++;
			if (_listLength > 0)
				return _list[-- _listLength];
			else
			{
				var newInstance:* = new _targetClass();
				if (newInstance is IPoolable)
					(newInstance as IPoolable).setPool(this);
				return newInstance;
			}
		}
		
		public function push(instance:*):*
		{
			_balance--;
			_list[_listLength ++] = instance;
			return null;
		}
		
		public function get balance():int
		{
			return _balance;
		}
	}
}