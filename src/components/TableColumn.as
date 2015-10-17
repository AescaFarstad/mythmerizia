package components 
{
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import util.DisplayMagic;

	public class TableColumn extends Sprite 
	{
		private var content:Vector.<DisplayObject>;
		private var rowHeight:Number;
		private var cellPadding:Number;
		private var sizer:Shape;
		private var fixedWidth:Number;
		
		public function TableColumn() 
		{
			
		}
		
		public function load(content:Vector.<DisplayObject>):void 
		{
			this.content = content;
			for (var i:int = 0; i < content.length; i++) 
			{
				if (content[i])
				{
					addChild(content[i]);
					content[i].x = cellPadding;
					content[i].y = rowHeight * i + cellPadding + (rowHeight - 2 * cellPadding - content[i].height)/2;
				}
			}
		}
		
		public function setup(rowHeight:Number, cellPadding:Number, fixedWidth:Number):void 
		{
			this.fixedWidth = fixedWidth;
			this.cellPadding = cellPadding;
			this.rowHeight = rowHeight;	
			if (fixedWidth)
			{
				sizer = new Shape();
				DisplayMagic.setSize(sizer, fixedWidth, 1);
				addChild(sizer);
			}
		}
		
		override public function get width():Number 
		{
			return fixedWidth == -1 ? super.width + cellPadding : fixedWidth;
		}
		
	}

}