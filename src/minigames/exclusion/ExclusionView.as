package minigames.exclusion 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ExclusionView extends Sprite
	{
		static public var ANIM_TIME:Number = 0.5;
		
		public var model:ExclusionModel;
		public var symbolViews:Vector.<SymbolView> = new Vector.<SymbolView>();
		public var isBlocked:Boolean;
		
		public function ExclusionView()
		{
			super();
		}
		
		public function load(model:ExclusionModel):void
		{
			this.model = model;
			var radius:int = 130;
			var sampleAngle:Number = Math.PI * 2 / model.symbols.length;
			for (var i:int = 0; i < model.symbols.length; i++)
			{
				var view:SymbolView = new SymbolView();
				addChild(view);
				view.load(model.symbols[i]);
				view.x = Math.cos(sampleAngle * i) * radius;
				view.y = Math.sin(sampleAngle * i) * radius;
				view.rotation = (sampleAngle * i + Math.PI) * 180 / Math.PI;
				symbolViews.push(view);
				
				view.addEventListener(MouseEvent.CLICK, onSymbolClick);
			}
			
			graphics.lineStyle(1, 0);
			graphics.beginFill(0, 0);
			graphics.drawCircle(0, 0, radius - 20);
			graphics.endFill();
		}
		
		private function onSymbolClick(e:MouseEvent):void
		{
			if (isBlocked)
				return;
			var view:SymbolView = e.currentTarget as SymbolView;
			model.nudge(view.symbol);
			isBlocked = true;
			TweenLite.delayedCall(ANIM_TIME, enableInput);
		}
		
		private function enableInput():void
		{
			isBlocked = false;
		}
		
	}
}