package util.binds 
{	
	import org.osflash.signals.Signal;
	
	public class Bind implements IBindable, IConnectable
	{
		private var _isRegistered:Boolean;
		
		protected var _name:String;
		protected var _bypassSave:Boolean;
	
		protected var _value:Number;
		protected var _onChange:Signal = new Signal();
		private var _connections:Vector.<ParamConnection> = new Vector.<ParamConnection>();
		
		public function Bind(name:String, value:Number = 0, bypassSave:Boolean = false)
		{
			_bypassSave = bypassSave;
			_value = value;
			_name = name;
		}
		
		public function get onChange():Signal
		{
			return _onChange;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(newValue:Number):void
		{
			if (!_isRegistered)
				throw new Error("Must register bind before using it. " + _name);
			if (newValue != _value)
			{
				_value = newValue;
				for (var j:int = 0; j < _connections.length; j++) 
				{
					_connections[j].propagate();
				}
				_onChange.dispatch();
			}
		}
		
		public function connect(to:Parameter, type:int):ParamConnection
		{
			var connection:ParamConnection = new ParamConnection(this, to, type, name + "->", this);
			_connections.push(connection);
			connection.propagate();
			return connection;
		}
		
		public function toString():String
		{
			return "BIND " + _name + "=" + (_value);
		}
		
		public function get bypassSave():Boolean
		{
			return _bypassSave;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set isRegistered(value:Boolean):void
		{
			_isRegistered = value;
		}
		
		public function get isRegistered():Boolean
		{
			return _isRegistered;
		}
		
		public function get connections():Vector.<ParamConnection>
		{
			return _connections;
		}
		
		public function clear():void
		{
			_onChange.removeAll();
			value = NaN;
		}
	}
}