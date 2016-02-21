package util.binds 
{
	

	public class ParamConnection 
	{
		static public const TYPE_ADD1:int = 0;
		static public const TYPE_MULTI:int = 1;
		static public const TYPE_ADD2:int = 2;
		
		public var to:Parameter;
		public var from:IBindable;
		public var source:String;
		public var debugSource:IBindable;
		public var type:int;
		private var _isEnabled:Boolean = true;
		
		public function ParamConnection(from:IBindable, to:Parameter, type:int, source:String, debugSource:IBindable) 
		{
			this.debugSource = debugSource;
			this.to = to;
			this.from = from;
			this.source = source;
			this.type = type;			
		}
		
		public function propagate():void 
		{
			if (!isEnabled)
				return;
			switch(type)
			{
				case TYPE_ADD1:
					{ 
						to.modify(from.value, 1, 0, source, debugSource);
						break; 
					}
				case TYPE_MULTI:
					{ 
						to.modify(0, from.value, 0, source, debugSource);
						break; 
					}
				case TYPE_ADD2:
					{ 
						to.modify(0, 1, from.value, source, debugSource);
						break; 
					}
			}
		}
		
		public function get isEnabled():Boolean
		{
			return _isEnabled;
		}
		
		public function set isEnabled(value:Boolean):void
		{
			_isEnabled = value;
			if (!_isEnabled)
				to.clearModifier(source);
			else
				propagate();
		}
		
		public static function typeByVal(value:int):String
		{
			switch(value)
			{
				case TYPE_ADD1:
				{
					return "ADD1";
				}
				case TYPE_MULTI:
				{
					return "MULTI";
				}
				case TYPE_ADD2:
				{
					return "ADD2";
				}
			}
			return null;
		}
		
		public static function operatorByVal(value:int):String
		{
			switch(value)
			{
				case TYPE_ADD1:
				{
					return "+";
				}
				case TYPE_MULTI:
				{
					return "*";
				}
				case TYPE_ADD2:
				{
					return "+";
				}
			}
			return null;
		}
		
	}

}