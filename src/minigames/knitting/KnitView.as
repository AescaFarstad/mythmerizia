package minigames.knitting 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import util.EnterFramer;
	import util.HMath;
	import util.trajectory.BSplineTrajectory;
	import util.trajectory.SplineTrajectory;
	
	public class KnitView extends Sprite
	{
		private var tension:Number = 1;
		private var precision:int = 1000;
		private var model:KnitModel;
		
		public function KnitView()
		{
			super();
			
		}
		
		public function load(model:KnitModel):void
		{
			this.model = model;
			render();
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		private function onFrame(e:Event):void
		{
			tension = HMath.linearInterp(0, 0.001, 800, 10, stage.mouseY);
			render();
		}
		
		private function render():void
		{
			graphics.clear();
			for (var i:int = 0; i < model.paths.length; i++)
			{
				drawPath(model.paths[i], i);
			}			
		}
		
		private function drawPath(path:Vector.<Point>, index:int):void
		{
			var trajectory:SplineTrajectory = new SplineTrajectory();
			trajectory.recalculateOnDemand = true;
			trajectory.controlPoints = path;
			trajectory.tension = tension;
			trajectory.t1 = 0;
			trajectory.t2 = precision;
			trajectory.moveTo(0);
			/*
			var trajectory:BSplineTrajectory = new BSplineTrajectory();
			trajectory.recalculateOnDemand = true;
			var points:Vector.<Point> = path.slice();
			points.unshift(path[0]);
			points.unshift(path[0]);
			points.unshift(path[0]);
			points.push(path[path.length - 1]);
			points.push(path[path.length - 1]);
			points.push(path[path.length - 1]);
			trajectory.controlPoints = path;
			trajectory.order = 3;
			trajectory.t1 = 0;
			trajectory.t2 = precision;
			trajectory.moveTo(0);*/
			
			//var colors:Array = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0x00ffff, 0xff00ff];
			var colors:Array = [0x2244bb, 0x2244bb, 0x2244bb, 0x2244bb, 0x2244bb, 0x2244bb];
			//graphics.lineStyle(2, 0x2244bb);
			graphics.lineStyle(2, colors[index]);
			graphics.moveTo(trajectory.x, trajectory.y);
			
			for (var i:int = 0; i < precision; i++)
			{
				trajectory.moveTo(i);
				graphics.lineTo(trajectory.x, trajectory.y);				
			}
			
			graphics.drawCircle(path[0].x, path[0].y, 2);
			graphics.drawCircle(path[path.length - 1].x, path[path.length - 1].y, 2);
		}
		
		
	}
}