package minigames.tsp.view 
{
	import engine.Animation;
	import flash.geom.Point;
	import minigames.tsp.Edge;
	import util.HMath;
	
	
	public class EdgeAnimation extends Animation 
	{
		private static const STEP_DURATION:int = 400;
		
		public var lastAppendedEdge:Edge;
		private var initialEdge:Edge;
		private var core:TSPCoreGameView;	
		
		private var tweens:Vector.<EdgeTween>;
		public var p1:Point = new Point();
		public var p2:Point = new Point();
		
		
		public function init(edge:Edge, core:TSPCoreGameView):void
		{
			this.core = core;
			this.initialEdge = edge;
			lastAppendedEdge = edge;
			_duration = int.MAX_VALUE;
			tweens = new Vector.<EdgeTween>();
		}
		
		public function appendEdge(edge:Edge, delay:int):void 
		{
			var tween:EdgeTween = new EdgeTween();
			tween.t1 = delay;
			tween.t2 = delay + STEP_DURATION;
			if (lastAppendedEdge.p1.distanceTo(edge.p1.x, edge.p1.y) + lastAppendedEdge.p2.distanceTo(edge.p2.x, edge.p2.y) >
				lastAppendedEdge.p1.distanceTo(edge.p2.x, edge.p2.y) + lastAppendedEdge.p2.distanceTo(edge.p1.x, edge.p1.y))
			{
				tween.fromP1 = lastAppendedEdge.p1;
				tween.fromP2 = lastAppendedEdge.p2;
				tween.toP1 = edge.p1;
				tween.toP2 = edge.p2;				
			}
			else
			{
				tween.fromP1 = lastAppendedEdge.p1;
				tween.fromP2 = lastAppendedEdge.p2;
				tween.toP1 = edge.p2;
				tween.toP2 = edge.p1;
			}
			tweens.push(tween);
			
			lastAppendedEdge = edge;
		}
		
		override public function update(timePassed:int):void 
		{
			_time += timePassed;
			if (tweens.length == 0)
			{
				p1 = initialEdge.p1.point.clone();
				p2 = initialEdge.p2.point.clone();
				return;
			}
			var tween:EdgeTween = tweens[tweens.length -1];
			var time:int = Math.min(tween.t2, Math.max(tween.t1, _time));
			p1.x = HMath.linearInterp(tween.t1, tween.fromP1.x, tween.t2, tween.toP1.x, time);
			p1.y = HMath.linearInterp(tween.t1, tween.fromP1.y, tween.t2, tween.toP1.y, time);
			p2.x = HMath.linearInterp(tween.t1, tween.fromP2.x, tween.t2, tween.toP2.x, time);
			p2.y = HMath.linearInterp(tween.t1, tween.fromP2.y, tween.t2, tween.toP2.y, time);
		}
	}

}