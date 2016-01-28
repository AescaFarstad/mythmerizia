package util.trajectory 
{
	import com.playflock.util.MathUtil;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TrajectoryVisualizer extends Sprite 
	{
		private var _trajectory:BaseTrajectory;
		private var _canvasWidth:Number = 400;
		private var _canvasHeight:Number = 400;
		private var _fromPoint:Point = new Point();
		private var _toPoint:Point = new Point();
		
		public function TrajectoryVisualizer() 
		{
			addEventListener(MouseEvent.CLICK, onCLick);
		}
		
		private function onCLick(e:MouseEvent):void 
		{
			if (e.localX > 0 && e.localX < _canvasWidth &&
				e.localY > 0 && e.localY < _canvasHeight)
			{
				_fromPoint.x = _toPoint.x;
				_fromPoint.y = _toPoint.y;
				_toPoint.x = e.localX;
				_toPoint.y = e.localY;
				setTrajectory();
				redraw();
			}
		}
		
		private function setTrajectory():void 
		{
			_trajectory.x1 = _fromPoint.x;
			_trajectory.y1 = _fromPoint.y;
			_trajectory.x2 = _toPoint.x;
			_trajectory.y2 = _toPoint.y;
			
			_trajectory.t1 = 0;
			_trajectory.t2 = 1;
			_trajectory.recalculateParams();
		}
		
		public function redraw():void
		{
			graphics.clear();
			graphics.beginFill(0, 0.8);
			graphics.drawRect(0, 0, _canvasWidth, _canvasHeight);
			graphics.endFill();
			
			var numSteps:int = Math.sqrt((_toPoint.x - _fromPoint.x) * (_toPoint.x - _fromPoint.x) + 
										(_toPoint.y - _fromPoint.y) * (_toPoint.y - _fromPoint.y)) / 10 + 10 + 50;
								
			graphics.lineStyle(1, 0xffffff);
			for (var i:int = 0; i < numSteps + 1; i++) 
			{
				graphics.lineStyle(2, MathUtil.linearInterp(0, 0xffffff, numSteps, 0xffffff, i));
				if (i != 0)
					graphics.moveTo(_trajectory.x, _trajectory.y);				
				_trajectory.moveTo(_trajectory.t1 + Number((_trajectory.t2 - _trajectory.t1) * i) / numSteps);
				if (i != 0)
					graphics.lineTo(_trajectory.x, _trajectory.y);
				graphics.lineStyle(1, 0xffffff);	
				graphics.drawCircle(_trajectory.x, _trajectory.y, 2);
			}
		}
		
		public function set trajectory(value:BaseTrajectory):void 
		{
			_trajectory = value;
			setTrajectory();
			redraw();
		}
		
		public function set canvasWidth(value:Number):void 
		{
			_canvasWidth = value;
			if (_trajectory)
				redraw();
		}
		
		public function set canvasHeight(value:Number):void 
		{
			_canvasHeight = value;
			if (_trajectory)
				redraw();
		}
		
	}

}