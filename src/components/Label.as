package components
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.engine.*
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	//Cut storing textBlocks in vector if not used
	
	public class Label extends Sprite
	{
		private var rawText:String;
		private var textBlocks:Vector.<TextBlock>;
		private var maxX:Number;
		private var maxY:Number;
		public var alignChar:String;
		private var align:String;
		private const blockSpacing:int = 1;
		private const lineSpacing:int = 1;
		
		public static const RIGHT_Align:String = "right";
		public static const LEFT_Align:String = "left";
		public static const CENTER_Align:String = "center";
		//public const CHAR_Align:String = "char";
		
		//"<#main#15:"
		
		public function Label(_align:String=LEFT_Align, _maxX:Number=2000, _maxY:Number=2000):void
		{
			maxX = _maxX;
			maxY = _maxY;
			align = _align;
			mouseEnabled = false;
			mouseChildren = false;
			
		}
		///Returns a sprite that displays the string in all initialized fonts along with their names
		public static function showAllFonts(sampleString:String=""):Sprite
		{
			if (sampleString == "")
			{
				sampleString = "Think of me long enough to make a memory";
			}
			
			var s:String = "#16#:"+sampleString;
			var sp:Sprite = new Sprite();
			
			var X:int = 0;
			var Y:int = 0;
			var label:Label;
			
			var fonts:Dictionary = Font.getFontsDictionary();
			for (var k:String in fonts) 
			{
				label = new Label();
				label.text = k+" "+"<#"+k + s;
				label.y = Y;
				label.x = X;
				Y += 20;
				sp.addChild(label);
			}
			/*
			label = new Label();
			label.text = "main "+"<#main" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "subtle "+"<#subtle" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint "+"<#hint" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint2 "+"<#hint2" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint2bold "+"<#hint2bold" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hintDaren "+"<#hintDarken" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint green "+"<#hint green" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint red "+"<#hint red" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "info "+"<#info" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side gold "+"<#side gold" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side metal "+"<#side metal" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side exp "+"<#side exp" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side energy "+"<#side energy" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side energy bold "+"<#side energy bold" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "black "+"<#black" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "black lite "+"<#black lite" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			*/
			return sp;
		}
		/*
		public static function showAll():Sprite
		{
			var s:String = "#16#:Think of me long enough to make a memory";
			var sp:Sprite = new Sprite();
			
			var X:int = 0;
			var Y:int = 0;
			var label:Label;
			
			label = new Label();
			label.text = "main "+"<#main" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "subtle "+"<#subtle" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint "+"<#hint" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint2 "+"<#hint2" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint2bold "+"<#hint2bold" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hintDaren "+"<#hintDarken" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint green "+"<#hint green" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "hint red "+"<#hint red" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "info "+"<#info" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side gold "+"<#side gold" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side metal "+"<#side metal" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side exp "+"<#side exp" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side energy "+"<#side energy" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "side energy bold "+"<#side energy bold" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "black "+"<#black" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			label = new Label();
			label.text = "black lite "+"<#black lite" + s;
			label.y = Y;
			label.x = X;
			Y += 20;
			sp.addChild(label);
			
			return sp;
		}
		*/
		public function set text(_text:String):void
		{
			if (rawText == _text)
			{
			    return;
			}
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			rawText = _text;			
			var elements:Vector.<ContentElement> = parseText(_text);
			var groups:Vector.<GroupElement> = new Vector.<GroupElement>();
			var group:GroupElement;
			var subElements:Vector.<ContentElement> = new Vector.<ContentElement>();
			for (var i:int = 0; i < elements.length; i++) 
			{
				if (elements[i] != null)
				{
					subElements.push(elements[i]);
				}
				else
				{
					group = new GroupElement(subElements);
					groups.push(group);
					subElements = new Vector.<ContentElement>();
				}
			}
			if (subElements.length != 0)
			{
				group = new GroupElement(subElements);
				groups.push(group);
			}
			//var ge:GroupElement = new GroupElement(elements);
			textBlocks = new Vector.<TextBlock>;
			var lineY:Number = 0;
			for (i= 0; i < groups.length; i++) 
			{
				textBlocks[i] = new TextBlock(groups[i]);
				lineY = placeTextBlock(textBlocks[i], lineY);
				lineY += blockSpacing;
			}
		}
		
		public function get text():String
		{
			return rawText;
		}		
		
		private function placeTextBlock(textBlock:TextBlock, lineY:Number):Number
		{			
			var line:TextLine = textBlock.createTextLine(null, maxX);
			while(line)
			{
			    addChild(line);
			    lineY += line.ascent+lineSpacing;
			    line.y = lineY;
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
 			    lineY += line.descent;
 			    line = textBlock.createTextLine(line, maxX);
			}
			return lineY;
		}
		
		private function parseText(s:String):Vector.<ContentElement>
		{
			var result:Vector.<ContentElement> = new Vector.<ContentElement>();
			var parts:Array = s.split("<#");
			var textElement:TextElement;
			var elementFormat:ElementFormat= Font.byName("jura#20");
			
			for (var i:int = 0; i < parts.length; i++) 
			{
				if (parts[i] != "")
				{
					//trace(parts[i]);
					var temp:int = parts[i].search("#:");
					
					if (temp >= 0)
					{
						elementFormat = Font.byName(parts[i].slice(0, temp));
						textElement = new TextElement(parts[i].slice(temp+2), elementFormat);
					}
					else
					{
						if (parts[i].indexOf("#>")!=-1)
						{
							result.push(null);
							var consText:String = parts[i].substr(parts[i].indexOf("#>") + 2);
							if (consText == "") { consText = " " };
							textElement = new TextElement(consText, elementFormat);							
						}
						else
						{
							textElement = new TextElement(parts[i], elementFormat);
						}
					}
					result.push(textElement);
				}
			}
			return result;
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
			textBlocks = null;
		}
	}
	
}