package components
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.engine.*
	import flash.text.TextFieldAutoSize;
	
	//Cut storing textBlocks in vector if not used
	
	public class SimpleLabel extends Sprite
	{
		private var rawText:String;
		private var textBlock:TextBlock;
		private var maxX:Number;
		private var align:String;
		private var _format:ElementFormat;
		
		public static const RIGHT_Align:String = "right";
		public static const LEFT_Align:String = "left";
		public static const CENTER_Align:String = "center";
		//public const CHAR_Align:String = "char";
		
		//"<#main#15:"
		
		public function SimpleLabel(_align:String=LEFT_Align, _maxX:Number=2000):void
		{
			maxX = _maxX;
			align = _align;
			mouseEnabled = false;
			mouseChildren = false;
			rawText = "";
		}
		///"main#15"
		public function set format(stringFormat:String):void
		{
			_format = Font.byName(stringFormat);
			processText(rawText);
		}
		
		public function set text(_text:String):void
		{
			if (rawText == _text)
			{
			    return;
			}			
			rawText = _text;			
			if (!_format)
			{
				format = "main#20";
			}	
			processText(_text);
		}
		
		private function processText(_text:String):void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			if (_text == "" || _text == null)
			{
				return;
			}
			var element:ContentElement = new TextElement(_text, _format);
			textBlock = new TextBlock(element);
			var line:TextLine = textBlock.createTextLine(null, maxX);
			addChild(line);
			line.y += line.ascent;
			switch(align)
			{
				case LEFT_Align:
				{
					break;
				}
				case RIGHT_Align:
				{
					line.x = (- line.width);
					break;
				}
				case CENTER_Align:
				{
					line.x = (- line.width) * 0.5;
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		
		public function kill():void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			if (parent)
			{
				parent.removeChild(this);
			}
			textBlock = null;
		}
	}
	
}