package util.layout 
{
	import flash.display.DisplayObject;
	
	/**
	 * Все поддерживаемые объекты target должны предоставлять для чтения свойства "x", "y", а тажке или должны
	 * реализовывать IBaseMeasurable (приоритетнее) или предоставлять для чтения свойства "width", "height"
	 */
	
	public final class MeasureUtil 
	{
		static public function getLeft(target:Object):int
		{
			// проверять? //
			return target.x;
		}
		
		static public function getRight(target:Object):int
		{
			// оптимизировать? //
			return getLeft(target) + getWidth(target);
		}
		
		static public function getTop(target:Object):int
		{
			// проверять? //
			return target.y;
		}
		
		static public function getBottom(target:Object):int
		{
			// оптимизировать? //
			return getTop(target) + getHeight(target);
		}
		
		static public function getHorCenter(target:Object):int
		{
			// оптимизировать? //
			return getLeft(target) + getHalfWidth(target);
		}
		
		static public function getVerCenter(target:Object):int
		{
			// оптимизировать? //
			return getTop(target) + getHalfHeight(target);
		}
		
		static public function getWidth(target:Object):int
		{
			// проверять? //
			var measurable:IBaseMeasurable = target as IBaseMeasurable;
			return (measurable ? measurable.baseWidth : target.width);
		}
		
		static public function getHeight(target:Object):int
		{
			// проверять? //
			var measurable:IBaseMeasurable = target as IBaseMeasurable;
			return (measurable ? measurable.baseHeight : target.height);
		}
		
		static public function getHalfWidth(target:Object):int
		{
			// оптимизировать? //
			return (getWidth(target) / 2);
		}
		
		static public function getHalfHeight(target:Object):int
		{
			// оптимизировать? //
			return (getHeight(target) / 2);
		}
		
		/** среди аргументов допустимы численные значения (в этом случае они будут также суммироваться) */
		static public function getSumWidth(... targets):int
		{
			// оптимизировать? //
			var sumWidth:int = 0;
			for each (var target:Object in targets)
			{
				if (target is Number)
					sumWidth += int(target);
				else
					sumWidth += getWidth(target);
			}
			return sumWidth;
		}
		
		/** среди аргументов допустимы численные значения (в этом случае они будут также суммироваться) */
		static public function getSumHeight(... targets):int
		{
			// оптимизировать? //
			var sumHeight:int = 0;
			for each (var target:Object in targets)
			{
				if (target is Number)
					sumHeight += int(target);
				else
					sumHeight += getHeight(target);
			}
			return sumHeight;
		}
		
		/** среди аргументов допустимы численные значения (в этом случае они будут также сравниваться) */
		static public function getMaxWidth(... targets):int
		{
			// оптимизировать? //
			var maxWidth:int = 0;
			for each (var target:Object in targets)
			{
				if (target is Number)
					maxWidth = Math.max(maxWidth, int(target));
				else
					maxWidth = Math.max(maxWidth, getWidth(target));
			}
			return maxWidth;
		}
		
		/** среди аргументов допустимы численные значения (в этом случае они будут также сравниваться) */
		static public function getMaxHeight(... targets):int
		{
			// оптимизировать? //
			var maxHeight:int = 0;
			for each (var target:Object in targets)
			{
				if (target is Number)
					maxHeight = Math.max(maxHeight, int(target));
				else
					maxHeight = Math.max(maxHeight, getHeight(target));
			}
			return maxHeight;
		}
	}
}