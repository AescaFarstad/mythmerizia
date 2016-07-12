package util 
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class Arrow
	{
		static public function drawArrow(canvas:Graphics, p1:Point, p2:Point, headSize:Number, headHalfAngle:Number):void
		{
			var vec:Point = p2.subtract(p1);
			var angle:Number = Math.atan2(vec.y, vec.x);
			canvas.moveTo(p1.x, p1.y);
			canvas.lineTo(p2.x, p2.y);
			
			var leftAngle:Number = angle + Math.PI - headHalfAngle;
			canvas.lineTo(p2.x + headSize * Math.cos(leftAngle), p2.y + headSize * Math.sin(leftAngle));
			
			canvas.moveTo(p2.x, p2.y);
			
			var rightAngle:Number = angle - Math.PI + headHalfAngle;
			canvas.lineTo(p2.x + headSize * Math.cos(rightAngle), p2.y + headSize * Math.sin(rightAngle));
			
		}
		
	}
}