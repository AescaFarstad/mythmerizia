package util.layout 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	public final class LayoutDebugUtil 
	{
		static public function addDebugShape(parent:DisplayObjectContainer, target:Object, frameColor:int = -1, fillColor:int = -1):Shape
		{
			var shape:Shape = new Shape();
			var graph:Graphics = shape.graphics;
			
			if (fillColor != -1)
				graph.beginFill(fillColor & 0xFFFFFF, 0.5);
			if (frameColor != -1)
				graph.lineStyle(0, frameColor & 0xFFFFFF, 1, true);
			graph.drawRect(0, 0, MeasureUtil.getWidth(target), MeasureUtil.getHeight(target));
			if (fillColor != -1)
				graph.endFill();
				
			shape.x = MeasureUtil.getLeft(target);
			shape.y = MeasureUtil.getTop(target);
			
			parent.addChild(shape);
			
			return shape;
		}
	}
}