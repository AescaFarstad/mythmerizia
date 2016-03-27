package minigames.clik_or_crit.view 
{
	import components.Label;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import minigames.clik_or_crit.model.CCModel;
	import minigames.clik_or_crit.model.Country;
	import minigames.clik_or_crit.model.Scouting;
	import org.osflash.signals.Signal;
	import util.HMath;
	
	public class MapOverlay extends Sprite 
	{
		private const minLabelDistance:int = 20;
		
		public var onCountryClick:Signal = new Signal(Country);		
		
		private var canvas:Sprite;
		private var borderCanvas:Sprite;
		private var label:Label;		
		private var visibleCountries:Vector.<Country>;
		private var vp:ViewPort;		
		
		public function MapOverlay() 
		{
			super();
			borderCanvas = new Sprite();
			addChild(borderCanvas);
			
			canvas = new Sprite();
			addChild(canvas);
			
			label = new Label();
			addChild(label);
			label.visible = false;
			label.filters = [new GlowFilter(0, 1, 4, 4, 4)];
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			var nearestCountry:Country = getNearestCountry(minLabelDistance, new Point(e.localX, e.localY));
			if (nearestCountry)
				onCountryClick.dispatch(nearestCountry);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			updateLabel(new Point(e.localX, e.localY));
		}
		
		private function updateLabel(p:Point):void
		{
			var nearestCountry:Country = getNearestCountry(minLabelDistance, p);
			if (nearestCountry)
			{
				var stageCoord:Point = vp.gameToStage(nearestCountry.lib.x, nearestCountry.lib.y);
				label.visible = true;
				label.text = S.format.gold(20) + nearestCountry.lib.name;
				label.x = stageCoord.x + 5;
				label.y = stageCoord.y - label.height - 2;
			}
			else
			{
				label.visible = false;
			}
		}
		
		private function getNearestCountry(radius:Number, loc:Point):Country
		{
			var nearestCountry:Country;
			var bestDistance:Number = Number.POSITIVE_INFINITY;
			for (var i:int = 0; i < visibleCountries.length; i++) 
			{
				var stageCoord:Point = vp.gameToStage(visibleCountries[i].lib.x, visibleCountries[i].lib.y);
				var len:Number = stageCoord.subtract(loc).length;
				if (len < radius && len < bestDistance)
				{
					bestDistance = len;
					nearestCountry = visibleCountries[i];
				}
			}
			return nearestCountry;
		}
		
		public function render(model:CCModel, vp:ViewPort, minScale:Number, maxScale:Number):void
		{
			this.vp = vp;
			
			var scouting:Scouting = model.scouting;
			
			canvas.graphics.clear();
			borderCanvas.graphics.clear();
			
			canvas.graphics.beginFill(0x0, 0);
			canvas.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			canvas.graphics.endFill();
			
			var radius:Number = HMath.linearInterp(minScale, 5, maxScale, 9, vp.scale);
			var radius2:Number = HMath.linearInterp(minScale, 5, maxScale, 30, vp.scale);
			
			visibleCountries = new Vector.<Country>();
			
			for (var i:int = 0; i < scouting.countries.length; i++) 
			{
				if (!scouting.countries[i].discovered)
					continue;
				var loc:Point = vp.gameToVisibleStage(scouting.countries[i].lib.x, scouting.countries[i].lib.y);
				if (loc)
				{
					if (!scouting.countries[i].building)
					{
						canvas.graphics.beginFill(scouting.countries[i].owned ? 0x33dd33 : 0x000077);
						canvas.graphics.drawCircle(loc.x, loc.y, radius);
						canvas.graphics.endFill();						
					}
					else
					{
						var rad2:Number = 1.8 * radius2;
						var maxWH:Number = Math.max(scouting.countries[i].building.pic.width, scouting.countries[i].building.pic.height);
						var radW:Number = rad2 * scouting.countries[i].building.pic.width / maxWH;
						var radH:Number = rad2 * scouting.countries[i].building.pic.height / maxWH;
						var scale:Number = 2 * rad2 / maxWH;
						
						var matrix:Matrix = new Matrix();
						matrix.scale(scale, scale);
						matrix.translate(loc.x - radW, loc.y - radH);
						
						canvas.graphics.beginBitmapFill(scouting.countries[i].building.pic, matrix, false, true);
						canvas.graphics.drawRect(loc.x - radW, loc.y - radH, 2 * radW, 2 * radH);
						canvas.graphics.endFill();
					}
					
					visibleCountries.push(scouting.countries[i]);
				}
			}
			
			if (stage)
				updateLabel(globalToLocal(new Point(stage.mouseX, stage.mouseY)));
				
			if (scouting.hull)
			{
				var lastCountry:Country = scouting.hull[scouting.hull.length - 1];
				borderCanvas.graphics.beginFill(0x33dd33, 0.4);
				loc = vp.gameToStage(lastCountry.lib.x, lastCountry.lib.y);
				borderCanvas.graphics.moveTo(loc.x, loc.y);
				for (i = 0; i < scouting.hull.length; i++) 
				{
					loc = vp.gameToStage(scouting.hull[i].x, scouting.hull[i].y);
					borderCanvas.graphics.lineTo(loc.x, loc.y);
				}
				borderCanvas.graphics.endFill();
			}
		}
		
		public function clear():void 
		{
			
		}
	}

}