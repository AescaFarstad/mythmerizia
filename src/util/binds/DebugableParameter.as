package util.binds 
{
	public class DebugableParameter extends Parameter
	{
		
		public function DebugableParameter(name:String, initWith:Number=NaN)
		{
			super(name, initWith);
			
		}
		
		public function get add1():Number
		{
			return _add1;
		}
		
		public function get add2():Number
		{
			return _add2;
		}
		
		public function get multi():Number
		{
			return _multi;
		}
		
		public function get modifiers():Vector.<Modifier>
		{
			return _modifiers;
		}
		
		public function getRealFormula():String
		{
			var add1Part:String = "";
			var add2Part:String = "";
			var multiPart:String = "";
			
			var add1:Number = 0;
			var add2:Number = 0;
			var multi:Number = 1;
			for (var i:int = 0; i < _modifiers.length; i++)
			{
				if (i != 0)
				{
					add1Part += " + ";
					add2Part += " + ";
					multiPart += " * ";
				}
				add1 += _modifiers[i].add1;
				add1Part += ""+_modifiers[i].add1;
				
				add2 += _modifiers[i].add2;
				add2Part += "" + modifiers[i].add2;
				
				multi *= _modifiers[i].multi;
				multiPart += "" + modifiers[i].multi;
			}
			var value:Number = add1 * multi + add2;
			
			var formula:String = "";
			if (modifiers.length > 1)
			{
				formula = StringUtil.substitute("({0}) * ({1}) + ({2})", add1Part, multiPart, add2Part);
			}
			if (modifiers.length == 1)
			{
				formula = StringUtil.substitute("{0} * {1} + {2}", add1Part, multiPart, add2Part);
			}
			
			var formula2:String = StringUtil.substitute("{0} * {1} + {2}", add1, multi, add2);
			var result:String = formula + " = " + formula2 + " = " + value;
			return result;
		}
		
		public function getShortFormula():String
		{
			var add1Part:String = "";
			var add2Part:String = "";
			var multiPart:String = "";
			var parts:Array = [
				add1Part, add2Part, multiPart
			];
			
			var add1:Number = 0;
			var add2:Number = 0;
			var multi:Number = 1;
			
			var add1Count:int = 0;
			var add2Count:int = 0;
			var multiCount:int = 0;
			
			for each (var modifier:Modifier in _modifiers)
			{
				var type:int = modifier.modifierType;
				var op:String = ParamConnection.operatorByVal(type);
				
				if (type == ParamConnection.TYPE_ADD1)
				{
					add1 += modifier.add1;
					add1Part += op + " " + modifier.add1;
					add1Count++;
				}
				if (type == ParamConnection.TYPE_MULTI)
				{
					multi *= modifier.multi;
					multiPart += op + " " + modifier.multi;
					multiCount++;
				}
				if (type == ParamConnection.TYPE_ADD2)
				{
					add2 += modifier.add2;
					add2Part += op + " " + modifier.add2;
					add2Count++;
				}
			}
			
			var value:Number = add1 * multi + add2;
			
			var formula1:String = "";
			if (add1Count > 0)
			{
				add1Part = trim(add1Part);
				
				if (add1Count > 1)
				{
					add1Part = surround(add1Part);
				}
			}
			else
			{
				add1Part = "0";
			}
			formula1 += add1Part;
			
			
			if (multiCount > 0)
			{
				multiPart = trim(multiPart);
				if (multiCount > 1)
				{
					multiPart = surround(multiPart);
				}
			}
			else
			{
				multiPart = "1";
			}
			
			formula1 += " * " + multiPart;
			
			
			if (add2Count > 0)
			{
				add2Part = trim(add2Part);
				
				if (add2Count > 1)
				{
					add2Part = surround(add2Part);
				}
				
				formula1 += " + " + add2Part;
			}
			
			return formula1;
			
			function trim(string:String):String
			{
				if (string.length >= 2)
				{
					return string.slice(2);
				}
				return "";
			}
			
			function surround(string:String):String
			{
				if (string.length > 0)
				{
					return "(" + string + ")";
				}
				return "";
			}
		}
		
	}
}