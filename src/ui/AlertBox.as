package ui 
{
	import components.Label;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import util.Button;
	import util.layout.LayoutGroup;
	import util.layout.LayoutUtil;
	
	
	public class AlertBox extends Sprite 
	{
		private var label:Label;
		private var buttons:Vector.<Button>;
		private var actions:Vector.<Function>;
		private var textWidth:int;
		
		public function AlertBox(parent:DisplayObjectContainer, text:String, textWidth:int, buttonLabels:Vector.<String>, actions:Vector.<Function>) 
		{
			super();
			this.textWidth = textWidth;
			this.actions = actions;
			parent.addChild(this);
			label = new Label(Label.CENTER_Align, textWidth);
			label.x = textWidth / 2;
			label.text = text;
			addChild(label);
			
			var lastX:int = 5;
			buttons = new Vector.<Button>();
			var buttonsGroup:LayoutGroup = new LayoutGroup();
			for (var i:int = 0; i < buttonLabels.length; i++) 
			{
				var button:Button = new Button(buttonLabels[i], onClick);
				buttons.push(button);
				addChild(button);
				buttonsGroup.addElement(button);
			}
			
			buttonsGroup.arrangeInHorizontalLineWithSpacing(20);
			LayoutUtil.moveToSameHorCenter(buttonsGroup, {width:textWidth});
			LayoutUtil.moveAtBottom(buttonsGroup, label, 20);
			
			render();
			
			x = parent.stage.stageWidth / 2 - width / 2;
			y = parent.stage.stageHeight / 2 - height / 2;
			
		}
		
		private function onClick(e:Event):void 
		{
			actions[buttons.indexOf(e.currentTarget)]();
			parent.removeChild(this);
		}
		
		private function render():void 
		{
			graphics.clear();
			graphics.beginFill(0xf7f7b7, 1);
			graphics.drawRect( -10, -10, textWidth + 20, buttons[0].y + buttons[0].height + 25);
			graphics.endFill();
		}
		
	}

}