package util.layout
{
	import com.playflock.util.SpriteUtil;
	import com.playflock.util.errors.AbstractMethodError;
	import com.playflock.util.interfaces.ILayoutable;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * Любые интерфейсные контэйнеры, унаследованные от этого класса,
	 * при выставлении ширины/высоты не будут масштабировать своих детей
	 * Гарантирует scaleX = scaleY = 1
	 */
	public class BaseLayoutable extends Sprite implements ILayoutable
	{
		private var _layoutRect:Rectangle = new Rectangle();
		private var _previousRect:Rectangle = new Rectangle();
		
		/**
		 * Pixel snap округляет координаты до ближайших <code>Int</code>.
		 * Используется для дебага размазанных менюшек.
		 */
		public var pixelSnap:Boolean = false;
		/**
		 * DebugMode отображает размер Layoutable контэйнера рисуя в его graphics
		 * Использутеся для дебага размеров
		 */
		private var _debugMode:Boolean = false;
		private var _debugColor:uint = 0x00ffff;
		
		public function BaseLayoutable()
		{
			super();
		}
		
		/***
		 * Layout overrides
		 * Позиция и размеры хранятся в _layoutRect и при изменении, не меняют скэйлы детей.
		 * При изменении позиций и размеров вызвается метод updateLayout.
		 */
		override public function set width(value:Number):void
		{
			if (pixelSnap)
			{
				value = Math.round(value);
			}
			_layoutRect.width = value;
			validate();
		}
		
		override public function get width():Number
		{
			return _layoutRect.width;
		}
		
		override public function set height(value:Number):void
		{
			if (pixelSnap)
			{
				value = Math.round(value);
			}
			_layoutRect.height = value;
			validate();
		}
		
		override public function get height():Number
		{
			return _layoutRect.height;
		}
		
		override public function get x():Number
		{
			return _layoutRect.x;
		}
		
		override public function set x(value:Number):void
		{
			if (pixelSnap)
			{
				value = Math.round(value);
			}
			
			if (value != _layoutRect.x)
			{
				_layoutRect.x = value;
				super.x = value;
			}
		}
		
		override public function get y():Number
		{
			return _layoutRect.y;
		}
		
		override public function set y(value:Number):void
		{
			if (pixelSnap)
			{
				value = Math.round(value);
			}
			
			if (value != _layoutRect.y)
			{
				_layoutRect.y = value;
				super.y = value;
			}
		}
		
		public function setLayout(x:int, y:int, width:int, height:int):void
		{
			_layoutRect.setTo(x, y, width, height);
			super.x = _layoutRect.x;
			super.y = _layoutRect.y;
			
			if (_layoutRect.width)
			validate();
			onLayoutUpdate();
		}
		
		protected function onLayoutUpdate():void
		{
		}
		
		public function setLayoutRect(rect:Rectangle):void
		{
			setLayout(rect.x, rect.y, rect.width, rect.height);
		}
		
		public function setLayoutDO(displayObject:DisplayObject):void
		{
			setLayout(displayObject.x, displayObject.y, displayObject.width, displayObject.height);
		}
		
		/**
		 * Если поменялась ширина или высота
		 * запрашиваем обновление
		 */
		private function validate():void
		{
			if (_debugMode)
			{
				updateBorders();
			}
			
			updateLayout();
		}
		
		protected function updateLayout():void
		{
			
		}
		
		protected function replace(oldChild:DisplayObject, newChild:*, keepSizes:Boolean = true, keepLink:Boolean = false, keepOldChild:Boolean = false):*
		{
			return SpriteUtil.replaceChild(oldChild, newChild, keepSizes, keepLink, keepOldChild);
		}
		
		
		
		public function get layoutRect():Rectangle
		{
			return _layoutRect;
		}
		
		private function updateBorders():void
		{
			function drawRect(graphics:Graphics, r:Rectangle, c:uint):void
			{
				graphics.clear();
				graphics.lineStyle(1, c);
				graphics.beginFill(c);
				graphics.drawRect(0, 0, r.width, r.height);
				graphics.endFill();
			}
			
			if (!_layoutRect || _layoutRect.width == 0 || _layoutRect.height == 0)
			{
				return;
			}
			
			drawRect(graphics, layoutRect, _debugColor);
		}
		
		public function get debugMode():Boolean
		{
			return _debugMode;
		}
		
		public function set debugMode(value:Boolean):void
		{
			if (value == true)
			{
				updateBorders();
			}
			
			_debugMode = value;
		}
		
		public function setDebugMode(value:Boolean, color:uint):BaseLayoutable
		{
			_debugColor = color;
			debugMode = value;
			
			return this;
		}
	}
}

