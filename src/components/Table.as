package components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	

	public class Table extends Sprite
	{
		private var content:Vector.<Vector.<DisplayObject>>;
		private var columns:Vector.<TableColumn>;
		private var rowHeight:Number = 20;
		private var dColumn:Number = 1;
		private var padding:Number = 1;
		private var cellPadding:Number = 1;
		
		public function Table() 
		{
			
		}
		
		public function setup(rowHeight:Number, dColumn:Number, padding:Number, cellPadding:Number):void
		{
			this.cellPadding = cellPadding;
			this.padding = padding;
			this.dColumn = dColumn;
			this.rowHeight = rowHeight;
		}
		
		///[col][row]
		public function load(content:Vector.<Vector.<DisplayObject>>, columnWidths:Vector.<Number> = null):void
		{
			this.content = content;
			columns = new Vector.<TableColumn>();
			
			for (var i:int = 0; i < content.length; i++) 
			{
				var column:TableColumn = new TableColumn();
				column.setup(rowHeight, cellPadding, columnWidths ? columnWidths[i] : -1);
				column.load(content[i]);
				addChild(column);
				columns.push(column);
				column.x = i == 0? padding : padding + columns[i - 1].x + columns[i - 1].width + dColumn;
				column.y = padding;				
			}
		}
		
		public function paint(backColor:uint, backAlpha:Number, colColor:uint, colAlpha:Number, cellColor:uint, cellAlpha:Number):void
		{
			graphics.clear();
			graphics.beginFill(backColor, backAlpha);
			graphics.drawRect(0, 0, columns[columns.length - 1].x + columns[columns.length - 1].width + padding, content[0].length * rowHeight + padding * 2);
			graphics.endFill();
			
			for (var i:int = 0; i < columns.length; i++) 
			{
				var columnWidth:Number = columns[i].width; 
				columns[i].graphics.clear();
				columns[i].graphics.beginFill(colColor, colAlpha);
				columns[i].graphics.drawRect(0, 0, columnWidth, content[0].length * rowHeight);
				columns[i].graphics.endFill();
				
				for (var j:int = 0; j < content[0].length; j++) 
				{
					columns[i].graphics.beginFill(cellColor, cellAlpha);
					columns[i].graphics.drawRect(1, j * rowHeight + 1, columnWidth - 1*2, rowHeight - 1 * 2);
					columns[i].graphics.endFill();
				}
			}
		}
		
	}

}