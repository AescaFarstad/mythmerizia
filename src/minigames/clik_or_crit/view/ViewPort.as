package minigames.clik_or_crit.view 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import util.HMath;
	
	public class ViewPort
	{
		private var _x:Number;
		private var _y:Number;
		public var width:Number;
		public var height:Number;
		public var angle:Number = 0;
		
		
		private var currentShift:Point = new Point();
		private var _scale:Number = 1;
		
		public var onChange:Signal = new Signal();
		
		public function ViewPort(x:Number=0, y:Number=0, width:Number=0, height:Number=0) 
		{
			_x = x;
			_y = y;
			this.width = width;
			this.height = height;
		}
		
		public function endShift():void
		{
			_x = _x + currentShift.x;
			_y = _y + currentShift.y;
			currentShift = new Point();
			onChange.dispatch();
		}
		
		public function shift(x:Number, y:Number):void
		{
			currentShift.setTo(-x / scale, -y / scale);
			onChange.dispatch();
		}
		
		public function get x():Number
		{
			return _x + currentShift.x;
		}
		
		public function set x(value:Number):void
		{
			_x = value - currentShift.x;
			onChange.dispatch();
		}
		
		public function get y():Number
		{
			return _y + currentShift.y;
		}
		
		public function set y(value:Number):void
		{
			_y = value -  + currentShift.y;
			onChange.dispatch();
		}
		
		public function get scale():Number 
		{
			return _scale;
		}
		
		public function applyScale(scale:Number, point:Point):void
		{
			var newWidth:Number = width * _scale / scale;
			_x += (width - newWidth) * point.x;
			width = newWidth;
			
			var newHeight:Number = height * _scale / scale;
			_y += (height - newHeight) * point.y;
			height = newHeight;
			_scale = scale;
			onChange.dispatch();
		}
		
		public function rotate(targetAngle:Number, origin:Point):void
		{
			var diff:Number = targetAngle - angle;

			//var enwCoords:Number = HMath.rotatePoint(new Point(x, y), diff, origin);
		}
		
		public function setTo(x:Number, y:Number, width:Number, height:Number):void 
		{
			_x = x;
			_y = y;
			this.width = width;
			this.height = height;
			onChange.dispatch();
		}
		
		public function stageToGame(x:Number, y:Number):Point
		{
			return new Point(x / _scale + _x, y / _scale + _y);
		}	
		
		
		public function gameToStage(x:Number, y:Number):Point
		{
			return new Point((x - this.x) * _scale, (y - this.y) * _scale);
		}
		
		public function gameToVisibleStage(x:Number, y:Number):Point
		{
			var result:Point = new Point((x - this.x) * _scale, (y - this.y) * _scale);
			return result.x >= 0 && result.x < width * _scale && result.y >= 0 && result.y < height * _scale ? result : null;
		}
	}

}