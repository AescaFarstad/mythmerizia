package minigames.clik_or_crit.view 
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import minigames.clik_or_crit.data.Hero;
	import util.HMath;
	
	

	public class DamageIndicator extends Shape 
	{
		private static const FADE_SPEED:Number = 0.002;
		private static const IMPULSE_STRENGTH:Number = 0.6;
		private var time:int;
		private var _alpha:Number;
		
		public function DamageIndicator() 
		{
			var mat:Matrix = new Matrix();
			var colors:Array = [0xff0000, 0xff0000, 0xff0000, 0xff0000];
			var alphas:Array = [0, 0, 1, 1];
			var ratios:Array = [0, 100, 250, 255];
			var circRad:Number = Hero.SIZE * CCView.SCALE;
			mat.createGradientBox(2 * circRad, 2 * circRad, 0, -circRad, -circRad);
			graphics.lineStyle();
			graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mat);
			graphics.drawCircle(0, 0, circRad);
			graphics.endFill();
			
			_alpha = 0;
			alpha = 0;
			cacheAsBitmap = true;
		}
		
		public function update(timePassed:int):void
		{
			time+= timePassed;
			_alpha -= FADE_SPEED * timePassed;
			alpha = Math.max(0, _alpha);
			//alpha = HMath.linearInterp(0, 1, FADE_DURATION, 0, time - lastTimeStamp);
		}
		
		public function impulse():void
		{
			_alpha += IMPULSE_STRENGTH;
			_alpha = Math.max(_alpha, IMPULSE_STRENGTH);
			_alpha = Math.min(_alpha, 1);
		}
		
	}

}