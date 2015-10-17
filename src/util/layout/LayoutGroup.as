package util.layout 
{

	public final class LayoutGroup implements IBaseMeasurable
	{
		private var _elements:Vector.<Object>;
		private var _horSpacing:int = 0;
		private var _verSpacing:int = 0;
		
		public function LayoutGroup(... elements) 
		{
			_elements = new Vector.<Object>;
			for each (var element:Object in elements)
				addElement(element);
		}
		
		public function addElement(element:Object):void
		{
			if (_elements.indexOf(element) == -1)
				_elements.push(element);
		}
		
		public function addElements(elementCollection:*):void
		{
			for each (var element:Object in elementCollection)
				addElement(element);
		}
		
		public function removeElement(element:Object):void
		{
			var index:int = _elements.indexOf(element);
			if (index >= 0)
				_elements.splice(index, 1);
		}
		
		public function clear():void
		{
			_elements.length = 0;
		}
		
		public function get baseWidth():int 
		{
			switch (_elements.length)
			{
				case 0:
					return 0;
				case 1:
					return MeasureUtil.getWidth(_elements[0]);
			}
			
			var minLeft:int = int.MAX_VALUE;
			var maxRight:int = int.MIN_VALUE;
			
			for each (var element:Object in _elements)
			{
				minLeft = Math.min(minLeft, MeasureUtil.getLeft(element));
				maxRight = Math.max(maxRight, MeasureUtil.getRight(element));
			}
			
			return maxRight - minLeft;
		}
		
		public function get baseHeight():int 
		{
			switch (_elements.length)
			{
				case 0:
					return 0;
				case 1:
					return MeasureUtil.getHeight(_elements[0]);
			}
			
			var minTop:int = int.MAX_VALUE;
			var maxBottom:int = int.MIN_VALUE;
			
			for each (var element:Object in _elements)
			{
				minTop = Math.min(minTop, MeasureUtil.getTop(element));
				maxBottom = Math.max(maxBottom, MeasureUtil.getBottom(element));
			}
			
			return maxBottom - minTop;
		}
		
		public function get x():int
		{
			switch (_elements.length)
			{
				case 0:
					return 0;
				case 1:
					return MeasureUtil.getLeft(_elements[0]);
			}
			
			var minLeft:int = int.MAX_VALUE;
			
			for each (var element:Object in _elements)
			{
				minLeft = Math.min(minLeft, MeasureUtil.getLeft(element));
			}
			
			return minLeft;
		}
		
		public function get y():int
		{
			switch (_elements.length)
			{
				case 0:
					return 0;
				case 1:
					return MeasureUtil.getTop(_elements[0]);
			}
			
			var minTop:int = int.MAX_VALUE;
			
			for each (var element:Object in _elements)
			{
				minTop = Math.min(minTop, MeasureUtil.getTop(element));
			}
			
			return minTop;
		}
		
		public function set x(value:int):void
		{
			var delta:int = value - this.x;
			
			if (delta == 0)
				return;
				
			for each (var element:Object in _elements)
			{
				LayoutUtil.setX(element, MeasureUtil.getLeft(element) + delta);
			}
		}
		
		public function set y(value:int):void
		{
			var delta:int = value - this.y;
			
			if (delta == 0)
				return;
				
			for each (var element:Object in _elements)
			{
				LayoutUtil.setY(element, MeasureUtil.getTop(element) + delta);
			}
		}
		
		/** выставить все элементы группы в линию с заданным расстоянием*/
		public function arrangeInHorizontalLineWithSpacing(spacing:Number):void 
		{
			for (var i:int = 1; i < _elements.length; i++)
			{
				LayoutUtil.moveAtRight(_elements[i], _elements[i - 1], spacing);
			}
		}
		
		public function arrangeInVerticalLineWithSpacing(spacing:Number):void 
		{
			for (var i:int = 1; i < _elements.length; i++) 
			{
				LayoutUtil.moveAtBottom(_elements[i], _elements[i - 1], spacing);
			}
		}

		public function get verSpacing():int
		{
			return _verSpacing;
		}

		public function set verSpacing(value:int):void
		{
			_verSpacing = value;
			arrangeInVerticalLineWithSpacing(value)
		}

		public function get horSpacing():int
		{
			return _horSpacing;
		}

		public function set horSpacing(value:int):void
		{
			_horSpacing = value;
			arrangeInHorizontalLineWithSpacing(value);
		}
	}
}