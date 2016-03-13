package util.binds 
{
	import flash.utils.Dictionary;
	import mx.utils.StringUtil;
	import org.osflash.signals.Signal;
	

	public class Parameter implements IBindable, IConnectable
	{
		static public const SOURCE_NEVER_OVERWRITE:String = "NEVER_OVERWRITE";
		
		private var _name:String;
		private var _onChange:Signal = new Signal();
		private var _modifiers:Vector.<Modifier> = new Vector.<Modifier>();
		private var _connections:Vector.<ParamConnection> = new Vector.<ParamConnection>();
		private var _value:Number;
		private var _debugSource:IBindable;
		private var _add1:Number;
		private var _add2:Number;
		private var _multi:Number;
		
		public function Parameter(name:String, initWith:Number = NaN) 
		{
			this._name = name;
			_value = 0;
			if (!isNaN(initWith))
				modify(initWith);
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		/*
		 * Если source совпадает с кем-то из имеющихся, то его значения заменяются. Иначе создаётся новый modifier
		 */
		public function modify(add1:Number = 0, multi:Number = 1, add2:Number = 0, source:String = "init", debugSource:IBindable = null):void
		{
			_debugSource = debugSource;
			
			if (source != SOURCE_NEVER_OVERWRITE)
			{
				for (var i:int = 0; i < _modifiers.length; i++) 
				{
					if (_modifiers[i].source == source)
					{
						_modifiers[i].setValue(add1, multi, add2);
						
						break;
					}
				}
			}
			
			if (i == _modifiers.length || source == SOURCE_NEVER_OVERWRITE)
			{
				var modifier:Modifier = new Modifier(add1, multi, add2, source, _debugSource);
				_modifiers.push(modifier);
			}
			recalculate();
		}
		
		public function clearModifier(source:String):void
		{
			for (var i:int = 0; i < _modifiers.length; i++) 
			{
				if (_modifiers[i].source == source)
				{
					_modifiers.splice(i, 1);					
					recalculate();
					return;
				}
			}
		}
		
		/*
		 * _value = add1 * multi + add2
		 */
		private function recalculate():void 
		{
			var oldValue:Number = _value;
			_add1 = 0;
			_add2 = 0;
			_multi = 1;
			for (var i:int = 0; i < _modifiers.length; i++) 
			{
				_add1 += _modifiers[i].add1;
				_add2 += _modifiers[i].add2;
				_multi *= _modifiers[i].multi;
			}
			_value = _add1 * _multi + _add2;
			if (_value != oldValue)
			{
				for (var j:int = 0; j < _connections.length; j++) 
				{
					_connections[j].propagate();
				}
				onChange.dispatch();
			}
		}
		
		public function connect(to:Parameter, type:int):ParamConnection
		{
			var connection:ParamConnection = new ParamConnection(this, to, type, _name + "->", this);
			_connections.push(connection);
			connection.propagate();
			return connection;
		}
		
		public function get onChange():Signal
		{
			return _onChange;
		}
		
		public function get connections():Vector.<ParamConnection>
		{
			return _connections;
		}
		
		public function get debugSource():IBindable
		{
			return _debugSource;
		}
		
		public function get name():String
		{
			return _name;
		}
	}

}