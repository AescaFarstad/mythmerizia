package minigames.clik_or_crit.view 
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import engine.Animation;
	import util.HMath;
	
	public class AttentionAnimation extends Animation 
	{
		private var size:int;
		
		private var timeline:TimelineMax;
		private var tweens:Array;
		
		public function AttentionAnimation() 
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function init(duration:int, size:int, numCircles:int = 10):void
		{
			this.size = size;
			_duration = duration;
			
			tweens = [];
			
			timeline = new TimelineMax( { paused:true } );
			
			for (var i:int = 0; i < numCircles; i++) 
			{
				tweens[i] = { r:size };
				var length:Number = HMath.nonlinearInterp(0, duration / numCircles / 1000 * 5, numCircles, duration / numCircles / 1000 * 2, 1, i);
				var timing:Number = HMath.nonlinearInterp(0, 0, numCircles, duration / 1000 - length, 0.7, i);
				timeline.insert(TweenLite.to(tweens[i], length, { r:0 } ), timing);
			}
		}
		
		override public function update(timePassed:int):void 
		{
			_time += timePassed;
			timeline.tweenTo(_time / 1000);
			render();
		}
		
		private function render():void 
		{
			graphics.clear();
			
			for (var i:int = 0; i < tweens.length; i++) 
			{
				graphics.lineStyle(5, 0x55ff33, HMath.linearInterp(0, 1, size, 0, tweens[i].r));
				graphics.drawCircle(0, 0, tweens[i].r);
			}
			
		}
		
	}

}