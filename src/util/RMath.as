package util 
{
	
	public class RMath 
	{
		
		public static function getItem(vec:*):*
		{
			return vec[int(vec.length * Math.random())];
		}
		
		public static function getWeightedItem(array:Array):*
		{
			var totalWeight:int = 0;
			for (var i:int = 0; i < array.length; i++) 
			{
				totalWeight += array[i].weight;
			}
			var point:int = Math.random() * totalWeight;
			for (i = 0; i < array.length; i++) 
			{
				point -= array[i].weight;
				if (point < 0)
					return array[i].value;
			}
			return null;
		}
		
		static public function weightedRandom(targetList:*, weights:*, count:int, unique:Boolean, 
				reverse:Boolean = false, reverseOffset:Number = 0):*
		{
			var sumOfWeights:Number = 0;
			var max:Number = Number.NEGATIVE_INFINITY;
			for (var k:int = 0; k < weights.length; k++)
			{
				sumOfWeights += weights[k];
				max = Math.max(max, weights[k]);
			}
			if (reverse)
			{
				sumOfWeights = 0;
				for (k = 0; k < weights.length; k++)
				{
					weights[k] = sumOfWeights + reverseOffset - weights[k];
					sumOfWeights += weights[k];
				}
			}
			var result:Array = [];
			for (var i:int = 0; i < count; i++)
			{
				var target:Number = Math.random() * sumOfWeights;
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
		
		static public function shuffleList(targetList:*):void
		{
			var length:int = targetList.length;
			if (length < 2)
				return;
			for (var i:int = 0; i < length - 1; i ++)
			{
				var j:int = Math.random() * (length - i) + i;
				var temp:* = targetList[i];
				targetList[i] = targetList[j];
				targetList[j] = temp;
			}
		}
		
	}

}