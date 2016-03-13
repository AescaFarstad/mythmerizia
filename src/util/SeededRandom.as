package util 
{
	public class SeededRandom
	{
		private var _seed:uint;
		private var _currentSeed:uint;
		
		public function SeededRandom(seed:uint = 0)
		{
			_seed = seed;
			_currentSeed = _seed;
		}
		
		public function get seed():uint 
		{
			return _seed;
		}
		
		public function set seed(value:uint):void 
		{
			_seed = value;
			_currentSeed = value;
		}
		
		/** reset generation seed value to last assigned value */
		public function resetSeed():void
		{
			_currentSeed = seed;
		}
		
		private function _generateRandom():Number
		{
			if (_seed == 0)
			{
				return Math.random();
			}
			else
			{
				_currentSeed = (_currentSeed * 16807) % 0x7FFFFFFF;
				if (_currentSeed == 0)
					_currentSeed ++;
				return _currentSeed / 0x7FFFFFFF + 0.000000000233;	// (1 - 0x7FFFFFFE / 0x7FFFFFFF) * 0.5 = 0.000000000233
			}
		}
		
		/** generates pseudo-random value (0 <= result < 1). */
		public function getRandom():Number
		{
			return _generateRandom();
		}
		
		/**
		 * generates random integer value
		 * @param	a	if only 1 argument specified, result will be in range [0..a] NOT including a.
		 * 	if both a and b arguments passed, result will be in range [a..b] NOT including b
		 * 	if no arguments passed, result will be in range [int.MIN_VALUE .. int.MAX_VALUE] NOT including int.MAX_VALUE
		 * @param	b	if specified, result will be in range [a..b] NOT including b
		 * @return	random integer value in range, depening on arguments passed
		 */
		public function getInt(a:int = int.MIN_VALUE, b:int = int.MIN_VALUE):int
		{
			if (b == int.MIN_VALUE)
			{
				if (a == int.MIN_VALUE)
				{
					b = int.MAX_VALUE;
				}
				else
				{
					b = a;
					a = 0;
				}
			}
			return Math.floor(a + (b - a) * _generateRandom());
		}
		
		/**
		 * generates random float (Number) value
		 * @param	a	if only 1 argument specified, result will be in range [0..a] NOT including a.
		 * 	if both a and b arguments passed, result will be in range [a..b] NOT including b
		 * 	if no arguments passed, result will be in range [int.MIN_VALUE .. int.MAX_VALUE] NOT including int.MAX_VALUE
		 * @param	b	if specified, result will be in range [a..b] NOT including b
		 * @return	random float value in range, depening on arguments passed
		 */
		public function getNumber(a:Number = NaN, b:Number = NaN):Number
		{
			if (isNaN(b))
			{
				if (isNaN(a))
				{
					a = Number.MIN_VALUE;
					b = Number.MAX_VALUE;
				}
				else
				{
					b = a;
					a = 0;
				}
			}
			else if (isNaN(a))
			{
				throw new ArgumentError();
			}
			return a + (b - a) * _generateRandom();
		}
		
		/**
		 * generates random boolean value
		 * @param	trueProbability	probability (in range [0..1]) of "true" result. If trueProbability = 0, result always will be "false".
		 * 	If trueProbability = 1, result always will be "true".
		 * @return random boolean value
		 */
		public function getBool(trueProbability:Number = 0.5):Boolean
		{
			return (_generateRandom() < trueProbability);
		}
		
		/**
		 * generates random sign (-1 or +1) value
		 * @param	positiveProbability	probability (in range [0..1]) of "1" result. If positiveProbability = 0, result always will be "-1".
		 * 	If positiveProbability = 1, result always will be "1".
		 * @return random int value (-1 or +1)
		 */
		public function getSign(positiveProbability:Number = 0.5):int
		{
			return (_generateRandom() < positiveProbability ? 1 : -1);
		}
		
		/**
		 * generates random string
		 * @param	maxLength	max allowed length of generated string
		 * @param	minLength	min allowed length of generated string
		 * @param	chars		string, containing set of chars, which must be used to generate string.
		 * 	If not specified, default set of chars will be used (a-z, A-Z, 0-9)
		 * @return	randomly generated string
		 */
		public function getString(maxLength:int, minLength:int = 0, chars:String = null):String
		{
			const DEFAULT_CHARS:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			if (!chars)
				chars = DEFAULT_CHARS;
			var result:String = "";
			var length:int = getInt(minLength, maxLength + 1);
			var charsLength:int = chars.length;
			for (var i:int = 0; i < length; i ++)
				result += chars.charAt(getInt(charsLength));
			return result;
		}
		
		/**
		 * returns random item of passed list
		 * @param	variantList	must be Array or Vector
		 * @return	randomly chosen item of variantList, or undefined, if list is empty
		 */
		public function getItem(variantList:*):*
		{
			if (variantList && variantList.length > 0)
				return variantList[getInt(variantList.length)];
			return undefined;
		}
		
		/** shuffles array/vector */
		public function shuffleList(targetList:*):void
		{
			var length:int = targetList.length;
			if (length < 2)
				return;
			for (var i:int = 0; i < length - 1; i ++)
			{
				var j:int = getInt(i, length);
				var temp:* = targetList[i];
				targetList[i] = targetList[j];
				targetList[j] = temp;
			}
		}
		
		public function weightedRandom(targetList:*, weights:*, count:int, unique:Boolean = true):*
		{
			var sumOfWeights:Number = 0;
			for (var k:int = 0; k < weights.length; k++)
			{
				sumOfWeights += weights[k];
			}
			var result:Array = [];
			for (var i:int = 0; i < count; i++)
			{
				var target:Number = getNumber(0, sumOfWeights);
				for (k = 0; k < weights.length; k++)
				{
					if (unique && result.indexOf(targetList[k]) != -1)
						continue;
					target -= weights[k];
					if (target <= 0)
					{
						result.push(targetList[k]);
						sumOfWeights -= weights[k];
						break;
					}
				}
			}
			
			return result;
		}
	}
}