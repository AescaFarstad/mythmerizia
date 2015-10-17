package util.layout 
{
	public final class LayoutUtil 
	{
		static public function setX(target:Object, x:int):void
		{
			target.x = x;
		}
		
		static public function setY(target:Object, y:int):void
		{
			target.y = y;
		}
		
		static public function setPos(target:Object, x:int, y:int):void
		{
			target.x = x;
			target.y = y;
		}
		
		static public function setWidth(target:Object, width:int):void
		{
			var targetAsResizable:IBaseResizable = target as IBaseResizable;
			if (targetAsResizable)
				targetAsResizable.baseWidth = width;
			else
				target.width = width;
		}
		
		static public function setHeight(target:Object, height:int):void
		{
			var targetAsResizable:IBaseResizable = target as IBaseResizable;
			if (targetAsResizable)
				targetAsResizable.baseHeight = height;
			else
				target.height = height;
		}
		
		static public function setSize(target:Object, width:int, height:int):void
		{
			var targetAsResizable:IBaseResizable = target as IBaseResizable;
			if (targetAsResizable)
			{
				targetAsResizable.baseWidth = width;
				targetAsResizable.baseHeight = height;
			}
			else
			{
				target.width = width;
				target.height = height;
			}
		}
		
		static public function setLayout(target:Object, x:int, y:int, width:int, height:int):void
		{
			setPos(target, x, y);
			setSize(target, width, height);
		}
		
		/** расположить слева от другого объекта (не меняя размер) */
		static public function moveAtLeft(target:Object, relative:Object, padX:int = 0):void
		{
			setX(target, MeasureUtil.getLeft(relative) - MeasureUtil.getWidth(target) + padX);
		}
		
		/** расположить справа от другого объекта (не меняя размер)*/
		static public function moveAtRight(target:Object, relative:Object, padX:int = 0):void
		{
			setX(target, MeasureUtil.getRight(relative) + padX);
		}
		
		/** расположить сверху от другого объекта (не меняя размер)*/
		static public function moveAtTop(target:Object, relative:Object, padY:int = 0):void
		{
			setY(target, MeasureUtil.getTop(relative) - MeasureUtil.getHeight(target) + padY);
		}
		
		/** расположить снизу от другого объекта (не меняя размер)*/
		static public function moveAtBottom(target:Object, relative:Object, padY:int = 0):void
		{
			setY(target, MeasureUtil.getBottom(relative) + padY);
		}
		
		/** расположить так, чтобы левые края совпали (не меняя размер)*/
		static public function moveToSameLeft(target:Object, relative:Object, padX:int = 0):void
		{
			setX(target, MeasureUtil.getLeft(relative) + padX);
		}
		
		/** расположить так, чтобы правые края совпали (не меняя размер)*/
		static public function moveToSameRight(target:Object, relative:Object, padX:int = 0):void
		{
			setX(target, MeasureUtil.getRight(relative) - MeasureUtil.getWidth(target) + padX);
		}
		
		/** расположить так, чтобы верхние края совпали (не меняя размер)*/
		static public function moveToSameTop(target:Object, relative:Object, padY:int = 0):void
		{
			setY(target, MeasureUtil.getTop(relative) + padY);
		}
		
		/** расположить так, чтобы нижние края совпали (не меняя размер)*/
		static public function moveToSameBottom(target:Object, relative:Object, padY:int = 0):void
		{
			setY(target, MeasureUtil.getBottom(relative) - MeasureUtil.getHeight(target) + padY);
		}
		
		/** расположить так, чтобы горизонтальные центры совпали (не меняя размер)*/
		static public function moveToSameHorCenter(target:Object, relative:Object, padX:int = 0):void
		{
			setX(target, MeasureUtil.getHorCenter(relative) - MeasureUtil.getHalfWidth(target) + padX);
		}
		
		/** расположить так, чтобы вертикальные центры совпали (не меняя размер)*/
		static public function moveToSameVerCenter(target:Object, relative:Object, padY:int = 0):void
		{
			setY(target, MeasureUtil.getVerCenter(relative) - MeasureUtil.getHalfHeight(target) + padY);
		}
		
		/** расположить так, чтобы центры совпали (не меняя размер)*/
		static public function moveToSameCenter(target:Object, relative:Object, padX:int = 0, padY:int = 0):void
		{
			moveToSameHorCenter(target, relative, padX);
			moveToSameVerCenter(target, relative, padY);
		}
		
		/** сделать ширину такой же как у другого объекта */
		static public function setSameWidth(target:Object, relative:Object, padWidth:int = 0):void
		{
			setWidth(target, MeasureUtil.getWidth(relative) + padWidth);
		}
		
		/** сделать высоту такой же как у другого объекта */
		static public function setSameHeight(target:Object, relative:Object, padHeight:int = 0):void
		{
			setHeight(target, MeasureUtil.getHeight(relative) + padHeight);
		}
		
		/** сделать размер (ширину и высоту) таким же как у другого объекта */
		static public function setSameSize(target:Object, relative:Object, padWidth:int = 0, padHeight:int = 0):void
		{
			setSameWidth(target, relative, padWidth);
			setSameHeight(target, relative, padHeight);
		}
		
		static public function setSameLayout(target:Object, relative:Object, padX:int = 0, padY:int = 0,
			padWidth:int = 0, padHeight:int = 0):void
		{
			moveToSameLeft(target, relative, padX);
			moveToSameTop(target, relative, padY);
			setSameSize(target, relative, padWidth, padHeight);
		}
		
		/** поменять ширину так, чтобы левые края совпали (если это возможно) */
		static public function growToSameLeft(target:Object, relative:Object, padLeft:int = 0):void
		{
			var newLeft:int = MeasureUtil.getLeft(relative) + padLeft;
			var targetRight:int = MeasureUtil.getRight(target);
			if (newLeft > targetRight)
				return;
			setWidth(target, targetRight - newLeft);
			setX(target, newLeft);
		}
		
		/** поменять ширину так, чтобы правые края совпали (если это возможно) */
		static public function growToSameRight(target:Object, relative:Object, padRight:int = 0):void
		{
			var newRight:int = MeasureUtil.getRight(relative) + padRight;
			var targetLeft:int = MeasureUtil.getLeft(target);
			if (newRight < targetLeft)
				return;
			setWidth(target, newRight - targetLeft);
		}
		
		/** поменять высоту так, чтобы верхние края совпали (если это возможно) */
		static public function growToSameTop(target:Object, relative:Object, padTop:int = 0):void
		{
			var newTop:int = MeasureUtil.getTop(relative) + padTop;
			var targetBottom:int = MeasureUtil.getBottom(target);
			if (newTop > targetBottom)
				return;
			setHeight(target, targetBottom - newTop);
			setY(target, newTop);
		}
		
		/** поменять высоту так, чтобы нижние края совпали (если это возможно) */
		static public function growToSameBottom(target:Object, relative:Object, padBottom:int = 0):void
		{
			var newBottom:int = MeasureUtil.getBottom(relative) + padBottom;
			var targetTop:int = MeasureUtil.getTop(target);
			if (newBottom < targetTop)
				return;
			setHeight(target, newBottom - targetTop);
		}
	}
}