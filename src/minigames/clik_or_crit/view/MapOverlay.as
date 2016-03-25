package minigames.clik_or_crit.view 
{
	import components.Label;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import minigames.clik_or_crit.model.CCModel;
	import minigames.clik_or_crit.model.Country;
	import org.osflash.signals.Signal;
	import util.HMath;
	
	public class MapOverlay extends Sprite 
	{
		private const minLabelDistance:int = 20;
		
		public var onCountryClick:Signal = new Signal(Country);		
		
		private var canvas:Sprite;
		private var label:Label;		
		private var visibleCountries:Vector.<Country>;
		private var vp:ViewPort;		
		
		public function MapOverlay() 
		{
			super();
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
			
			canvas.graphics.clear();
			
			canvas.graphics.beginFill(0x0, 0);
			canvas.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			canvas.graphics.endFill();
			
			var radius:Number = HMath.linearInterp(minScale, 3, maxScale, 7, vp.scale);
			
			visibleCountries = new Vector.<Country>();
			
			for (var i:int = 0; i < model.countries.length; i++) 
			{
				if (!model.countries[i].discovered)
					continue;
				var loc:Point = vp.gameToVisibleStage(model.countries[i].lib.x, model.countries[i].lib.y);
				if (loc)
				{
					canvas.graphics.beginFill(model.countries[i].owned ? 0x33dd33 : 0x000077);
					canvas.graphics.drawCircle(loc.x, loc.y, radius);
					canvas.graphics.endFill();
					
					visibleCountries.push(model.countries[i]);
				}
			}
			
			if (stage)
				updateLabel(globalToLocal(new Point(stage.mouseX, stage.mouseY)));
				
			if (model.hull)
			{
				var lastCountry:Country = model.hull[model.hull.length - 1];
				canvas.graphics.beginFill(0x33dd33, 0.4);
				loc = vp.gameToStage(lastCountry.lib.x, lastCountry.lib.y);
				canvas.graphics.moveTo(loc.x, loc.y);
				for (i = 0; i < model.hull.length; i++) 
				{
					loc = vp.gameToStage(model.hull[i].x, model.hull[i].y);
					canvas.graphics.lineTo(loc.x, loc.y);
				}
				canvas.graphics.endFill();
			}
		}
	}

}