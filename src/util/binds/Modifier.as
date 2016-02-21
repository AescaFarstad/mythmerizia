package util.binds 
{
	import mx.utils.StringUtil;
	
	
	public class Modifier 
	{
		private var _debugSource:IBindable;
		private var _source:String;
		private var _add1:Number;
		private var _add2:Number;
		private var _multi:Number;
		
		public function Modifier(add1:Number, multi:Number, add2:Number, source:String = "init", debugSource:IBindable = null) 
		{
			if (isNaN(add1) || isNaN(multi) || isNaN(add2))
				throw new Error();
			
			_debugSource = debugSource;
			_source = source;
			
			setValue(add1, multi, add2);
		}
		
		public function setValue(add1:Number, multi:Number, add2:Number):void
		{
			_add1 = add1;
			_add2 = add2;
			_multi = multi;
			
			if (CONFIG::debug)
			{
				checkIsValid();
			}
		}
		
		public function get value():Number
		{
			if (_add1 != 0)
			{
				return _add1;
			}
			if (_multi != 1)
			{
				return _multi;
			}
			if (_add2 != 0)
			{
				return _add2;
			}
			return NaN;
		}
		
		public function toString():String
		{
			return StringUtil.substitute("[add1:{0}] [multi:{1}] [add2:{2}]", _add1, _multi, _add2);
		}
		
		private function checkIsValid():void
		{
			var check:int = 0;
			if (add1 != 0)
			{
				check++;
			}
			if (multi != 1)
			{
				check++;
			}
			if (add2 != 0)
			{
				check++;
			}
			if (check > 1)
			{
				throw new Error("Modifier modify too much " + source);
			}
		}
		
		/**
		 * @return тип модификатора. Если модификатор ничего не меняет, возвращает -1
		 */
		public function get modifierType():int
		{
			if (_add1 != 0)
			{
				return ParamConnection.TYPE_ADD1;
			}
			if (_multi != 1)
			{
				return ParamConnection.TYPE_MULTI;
			}
			if (_add2 != 0)
			{
				return ParamConnection.TYPE_ADD2;
			}
			return -1;
		}

		public function get isEmpty():Boolean
		{
			return (modifierType < 0);
		}
		
		public function get multi():Number
		{
			return _multi;
		}
		
		public function get add2():Number
		{
			return _add2;
		}
		
		public function get add1():Number
		{
			return _add1;
		}
		
		public function get source():String
		{
			return _source;
		}
		
		public function get debugSource():IBindable
		{
			return _debugSource;
		}
	}
}