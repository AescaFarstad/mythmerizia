package minigames.quad 
{
	import com.greensock.TweenLite;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import util.Arrow;
	import util.HMath;
	
	public class SingleQuadView extends Sprite
	{
		public static const SIZE:int = 50;
		private var numVert:int;
		public var quad:Quad;
		private var cursor:CursorView;
		public var model:QuadModel;
		private var segments:Vector.<QuadSegment>;
		private var arrowSprite:Sprite;
		
		public function SingleQuadView(numVert:int)
		{
			this.numVert = numVert;
			
			graphics.lineStyle(4, 0x33e993);
			drawPolygon(graphics, SIZE);
			
			segments = new Vector.<QuadSegment>();
			for (var i:int = 0; i < numVert; i++)
			{
				var segment:QuadSegment = new QuadSegment(pointByIndex(i, numVert, SIZE), pointByIndex((i + 1) % numVert, numVert, SIZE), this);
				segments.push(segment);
			}
			
			cursor = new CursorView();
			addChild(cursor);
			
			drawCursor(0x23e993);
			
			arrowSprite = new Sprite();
			addChild(arrowSprite);
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		private function drawCursor(color:uint):void
		{
			cursor.graphics.clear();
			cursor.graphics.lineStyle(4, color);
			cursor.graphics.beginFill(0xffffff, 1);
			drawPolygon(cursor.graphics, SIZE / 3);
			cursor.graphics.endFill();			
		}
		
		private function drawPolygon(target:Graphics, size:int):void
		{			
			for (var i:int = 0; i < numVert+1; i++)
			{
				var point:Point = pointByIndex(i % numVert, numVert, size);
				target.moveTo(point.x, point.y);
				point = pointByIndex((i + 1) % numVert, numVert, size);
				target.lineTo(point.x, point.y);
			}			
		}
		
		static public function pointByIndex(index:int, numVert:int, size:int):Point
		{
			var angle:Number = Math.PI * 2 * index / numVert;
			return new Point(size * Math.cos(angle), size * Math.sin(angle));
		}
		
		public function load(quad:Quad, model:QuadModel):void
		{
			this.model = model;
			this.quad = quad;
			update();
		}
		
		public function update():void
		{
			var loc:Point = pointByIndex(quad.index, numVert, SIZE);
			TweenLite.to(cursor, 1, { x:loc.x, y:loc.y } );
			if (!quad.isRight)
				drawCursor(0x23e993);
			else				
				TweenLite.delayedCall(1, drawCursor, [0xffff00]);
		}
		
		public function onMouseMove(point:Point):int
		{
			arrowSprite.graphics.clear();
			arrowSprite.graphics.lineStyle(5, 0x23e993);
			var nearestSegment:QuadSegment = findNearestSegment(point);
			if (quad.index == segments.indexOf(nearestSegment))
			{
				Arrow.drawArrow(arrowSprite.graphics, nearestSegment.p1, nearestSegment.p2, 15, Math.PI / 6);
				return 1;
			}
			else if (quad.index == (segments.indexOf(nearestSegment) + 1) % numVert)
			{
				Arrow.drawArrow(arrowSprite.graphics, nearestSegment.p2, nearestSegment.p1, 10, Math.PI / 6);
				return -1;
			}			
			return 0;
		}
		
		public function hideArrow():void
		{
			arrowSprite.graphics.clear();
		}
		
		public function onMouseDown(point:Point):Boolean
		{
			var nearestSegment:QuadSegment = findNearestSegment(point);
			if (quad.index == segments.indexOf(nearestSegment))
			{
				model.triggerQuad(quad, 1);
				return true;
			}
			else if (quad.index == (segments.indexOf(nearestSegment) + 1) % numVert)
			{
				model.triggerQuad(quad, -1);
				return true;
			}
			return false;
		}
		
		private function findNearestSegment(point:Point):QuadSegment
		{
			var bestDistance:Number = Number.POSITIVE_INFINITY;
			var bestSegment:QuadSegment;
			for (var i:int = 0; i < segments.length; i++)
			{
				var distance:Number = HMath.distance(point, segments[i].center);// HMath.distanceFromPointToSegment(point.x, point.y, segments[i].p1.x, segments[i].p1.y, segments[i].p2.x, segments[i].p2.y);
				if (distance < bestDistance)
				{
					bestDistance = distance;
					bestSegment = segments[i];
				}
			}
			return bestSegment;
		}
		
	}
}