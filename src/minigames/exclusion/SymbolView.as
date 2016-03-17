package minigames.exclusion 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	
	public class SymbolView extends Sprite
	{
		private var indexSprite:Sprite;
		public var symbol:Symbol;
		
		public function SymbolView()
		{
			super();
			
		}
		
		public function load(symbol:Symbol):void
		{
			this.symbol = symbol;
			var sampleAngle:Number = Math.PI * 2 / symbol.modulo;
			var radius:Number = 30;
			for (var i:int = 0; i < symbol.modulo; i++)
			{
				var rad:Number = i == 0 ? radius + 20 : radius;
				graphics.beginFill(0, 1);
				graphics.drawCircle(rad * Math.cos(sampleAngle * i), rad * Math.sin(sampleAngle * i), 4);
				graphics.endFill();				
			}
			graphics.lineStyle(2, 0);
			graphics.moveTo(rad * Math.cos(sampleAngle * (symbol.modulo - 1)), rad * Math.sin(sampleAngle * (symbol.modulo - 1)));
			
			for (i = 0; i < symbol.modulo; i++)
			{
				rad = i == 0 ? radius + 20 : radius;
				graphics.lineTo(rad * Math.cos(sampleAngle * i), rad * Math.sin(sampleAngle * i));
			}
			
			indexSprite = new Sprite();
			indexSprite.graphics.beginFill(0xff7700);			
			indexSprite.graphics.drawCircle(0, 0, 5);
			indexSprite.graphics.endFill();
			addChild(indexSprite);
			
			rad = symbol.index == 0 ? radius + 20 : radius;
			indexSprite.x = rad * Math.cos(sampleAngle * symbol.index);
			indexSprite.y = rad * Math.sin(sampleAngle * symbol.index);
			
			graphics.lineStyle(1, 0, 0);
			graphics.beginFill(0, 0);
			graphics.drawCircle(0, 0, radius + 20);
			graphics.endFill();
			
			symbol.onIndexChanged.add(onIndexChanged);
			function onIndexChanged():void
			{
				rad = symbol.index == 0 ? radius + 20 : radius;
				TweenLite.to(indexSprite, ExclusionView.ANIM_TIME, {
					x:rad * Math.cos(sampleAngle * symbol.index), 
					y:rad * Math.sin(sampleAngle * symbol.index)
					});
			}
		}
		
	}
}