package minigames.clik_or_crit.view 
{
	import engine.AnimUpdater;
	import engine.Animation;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import minigames.bmd.Building;
	import minigames.clik_or_crit.lib.BuildingItem;
	import minigames.clik_or_crit.model.CCModel;
	import minigames.clik_or_crit.model.Country;
	import minigames.clik_or_crit.model.Scouting;
	import util.HMath;
	
	public class MapView extends Sprite 
	{		
		private const minScale:Number = 720;
		private const maxScale:Number = 14400;
		private const maxLinearScale:Number = 100;
		private const minLinearScale:Number = 1;
		
		private var linearScale:int;
		
		private var model:CCModel;
		private var scouting:Scouting;
		
		private var vp:ViewPort = new ViewPort();
		private var isDragging:Boolean;
		private var dragStartPoint:Point;
		private var ignoreNextClick:Boolean;
		
		private var bg:BGView;
		private var overlay:MapOverlay;
		private var countryMenu:CountryMenu;
		
		public var updater:AnimUpdater;
		
		
		public function MapView() 
		{
			super();
			bg = new BGView();
			addChild(bg);
			
			overlay = new MapOverlay();
			addChild(overlay);
			
			countryMenu = new CountryMenu();
			addChild(countryMenu);
			countryMenu.visible = false;
			
			updater = new AnimUpdater();
		}
		
		public function load(model:CCModel):void 
		{
			this.model = model;
			scouting = model.scouting;
			vp.setTo(0, 0, stage.stageWidth, stage.stageHeight);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			linearScale = minLinearScale  + 10;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			updateLinearScale(new Point());
			
			countryMenu.load(model, vp);
			
			overlay.onCountryClick.add(onCountryClick);
			scouting.onCountryTaken.add(onCountryTaken);
			scouting.onCountryDiscovered.add(onCountryDiscovered);			
			scouting.onBuildingConstructed.add(onBuildingConstructed);	
		}
		
		private function onBuildingConstructed(building:BuildingItem, country:Country):void 
		{
			render();
		}
		
		private function onCountryTaken(country:Country):void 
		{
			render();
		}
		
		private function onCountryDiscovered(country:Country):void 
		{
			render();
			var anim:AttentionAnimation = new AttentionAnimation();
			overlay.addChild(anim);
			anim.init(2000, 200, 8);
			updater.push(anim);
			anim.tag = new ViewPortBinder(country, anim, vp);
			anim.onUnplugged.addOnce(clearBinders);
			
			function clearBinders(anim:Animation):void
			{
				(anim.tag as ViewPortBinder).cleanUp();
				overlay.removeChild(anim);
			}			
		}
		
		private function onCountryClick(country:Country):void 
		{
			if (!country.owned)
				model.input.takeCountry(country);
			else
				countryMenu.show(country);
		}
		
		private function render():void 
		{
			overlay.render(model, vp, minScale, maxScale);
			bg.render(model, vp);
		}
		
		public function applyScale(scale:Number, source:Point):void 
		{
			vp.applyScale(scale, source);
			render();
		}
		
		public function updateScale():void
		{
			applyScale(vp.scale, new Point(0.5, 0.5));
		}
		
		public function endShift():void 
		{
			vp.endShift();
		}
		
		public function shiftPort(x:Number, y:Number):void 
		{
			vp.shift(x, y);
			updateScale();
		}
		
		public function update(timePassed:int):void 
		{
			updater.update(timePassed);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			dragStartPoint = new Point(e.stageX, e.stageY);
			isDragging = true;
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var result:Point = new Point(e.stageX - dragStartPoint.x, e.stageY - dragStartPoint.y);
			shiftPort(result.x, result.y);
			if (result.length > 10)
				ignoreNextClick = true;
			
			countryMenu.hide();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			isDragging = false;
			endShift();
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onWheel(e:MouseEvent):void 
		{
			if (isDragging)
				return;
			linearScale += e.delta;			
			var sourcePoint:Point = new Point(e.stageX, e.stageY);
			sourcePoint.x /= stage.stageWidth;
			sourcePoint.y /= stage.stageHeight;
			updateLinearScale(sourcePoint);
		}
		
		private function updateLinearScale(sourcePoint:Point = null):void
		{
			if (!sourcePoint)
				sourcePoint = new Point(0.5, 0.5);
			linearScale = Math.max(Math.min(maxLinearScale, linearScale), minLinearScale);
			var scale:Number = HMath.nonlinearInterp(minLinearScale, minScale, maxLinearScale, maxScale, 1.5, linearScale);
			applyScale(scale, sourcePoint);
			countryMenu.hide();
		}
		
	}

}