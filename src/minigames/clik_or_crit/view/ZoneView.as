package minigames.clik_or_crit.view 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import minigames.clik_or_crit.data.HeroPrototype;
	import minigames.clik_or_crit.data.IZoneListener;
	import minigames.clik_or_crit.data.Zone;
	
	
	public class ZoneView extends Sprite implements IZoneListener
	{
		private static const PACK_HEIGHT:int = 20;
		private static const PACK_CELL_WIDTH:int = 20;
		
		private var zone:Zone;
		private var arrow:Bitmap;
		
		public function ZoneView() 
		{
		}
		
		public function load(zone:Zone):void
		{
			this.zone = zone;
			zone.listener = this;
			render();
			cacheAsBitmap = true;
		}
		
		public function onProgress():void 
		{
			render();
		}
		
		private function render():void 
		{
			graphics.clear();
			var arrowOffset:int = -1;
			var currentOffset:int;
			for (var i:int = 0; i < zone.packs.length; i++) 
			{
				var thisSize:int =  zone.packs[i] ? zone.packs[i].length : 1;
				drawPack(zone.packs[i], currentOffset, thisSize);
				if (i < zone.currentIndex)
					arrowOffset += thisSize;
				currentOffset += thisSize;
			}
			if (!arrow)
			{
				var targetSize:int = 20;
				arrow = new Bitmap(S.pics.clickOrCrit.upArrow);
				arrow.smoothing = true;
				arrow.scaleX = arrow.scaleY = Math.min(targetSize / arrow.width, targetSize / arrow.height);
				addChild(arrow);
			}
			arrow.x = PACK_CELL_WIDTH * arrowOffset + 2;
			arrow.y = PACK_HEIGHT + 3;
		}
		
		private function drawPack(pack:Vector.<HeroPrototype>, offset:int, thisSize:int):void 
		{
			if (pack)
			{
				padding = 1;
				
				graphics.lineStyle(1, 0, 1);
				graphics.beginFill(0, 0);
				graphics.drawRect(offset * PACK_CELL_WIDTH + padding, padding, thisSize * PACK_CELL_WIDTH - 2*padding, PACK_HEIGHT - 2*padding);
				graphics.endFill();
				
				
				graphics.lineStyle(3, 0, 1);
				for (var i:int = 0; i < pack.length; i++) 
				{
					graphics.drawCircle((offset + 0.5 + i) * PACK_CELL_WIDTH, PACK_HEIGHT / 2, 1);
				}
				
			}
			else
			{
				var padding:Number = 4;
				graphics.lineStyle(2, 0, 1);
				graphics.moveTo(offset * PACK_CELL_WIDTH + padding, padding);
				graphics.lineTo((offset + 1) * PACK_CELL_WIDTH - padding, PACK_HEIGHT - padding);
				graphics.moveTo((offset + 1) * PACK_CELL_WIDTH - padding, padding);
				graphics.lineTo(offset * PACK_CELL_WIDTH + padding, PACK_HEIGHT - padding);
			}
		}
		
	}

}