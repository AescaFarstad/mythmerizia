package minigames.roads 
{
	import components.Label;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import util.HMath;
	import util.layout.LayoutUtil;
	
	public class RoadsView extends Sprite
	{
		public var model:RoadsModel;
		static public var scale:Number = 100;
		
		public var stationViews:Vector.<StationView> = new Vector.<StationView>();
		public var carViews:Vector.<CarView> = new Vector.<CarView>();
		public var moneyLabel:Label;
		public var currentRoad:Road;
		public var fixedRoad:Road;
		public var roadView:RoadInfo;
		
		public function RoadsView()
		{
			super();
			moneyLabel = new Label();
			addChild(moneyLabel);
			
			roadView = new RoadInfo();
			addChild(roadView);
		}
		
		public function load(model:RoadsModel):void
		{
			this.model = model;
			
			for (var i:int = 0; i < model.stations.length; i++)
			{
				var view:StationView = new StationView();
				view.load(model.stations[i], model);
				addChild(view);
				stationViews.push(view);
			}
			
			for (i = 0; i < model.cars.length; i++)
			{
				addCarView(model.cars[i]);
			}
			
			model.onCarSpawned.add(onCarSpawned);
			model.onCarExit.add(onCarExit);
			model.money.onChange.add(onMoneyChanged)
			onMoneyChanged();
			addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (currentRoad)
			{
				model.upTmpCapacity(currentRoad);
				fixedRoad = currentRoad;
			}
				
			roadView.load(fixedRoad, model);
			
			LayoutUtil.moveToSameRight(roadView, { x:0, width:stage.stageWidth - 50 } );
		}
		
		private function onMove(e:MouseEvent):void
		{
			var loc:Point = globalToLocal(new Point(e.stageX, e.stageY));
			loc.x /= scale;
			loc.y /= scale;
			currentRoad = findNearestRoad(loc);
		}
		
		private function findNearestRoad(point:Point):Road
		{
			var bestDistance:Number = Number.POSITIVE_INFINITY;
			var bestSegment:Road;
			for (var i:int = 0; i < model.roads.length; i++)
			{
				var distance:Number = HMath.distance(point, model.roads[i].center);
				if (distance < bestDistance)
				{
					bestDistance = distance;
					bestSegment = model.roads[i];
				}
			}
			if (bestDistance < 1)
				return bestSegment;
			return null;
		}
		
		private function onMoneyChanged():void
		{
			moneyLabel.text = S.format.black(24) + model.money.value.toFixed();
			LayoutUtil.moveToSameRight(moneyLabel, { x:0, width:stage.stageWidth - 50 } );
			moneyLabel.y = -50;
		}
		
		private function onCarExit(car:Car):void
		{
			for (var i:int = 0; i < carViews.length; i++)
			{
				if (carViews[i].car == car)
				{
					removeChild(carViews[i])
					carViews.splice(i, 1);
					return;
				}
			}
		}
		
		private function onCarSpawned(car:Car):void
		{
			addCarView(car);
		}
		
		private function addCarView(car:Car):void
		{
			var carView:CarView = new CarView();
			carView.load(car, model);
			addChild(carView);
			carViews.push(carView);
		}
		
		public function update(timePassed:int):void
		{
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 1000, 1000);			
			
			drawPoints();
			drawStations();
			drawRoads();
			
			for (var i:int = 0; i < carViews.length; i++)
			{
				var p1:Point = carViews[i].car.direction > 0 ? carViews[i].car.road.p1 : carViews[i].car.road.p2;
				var p2:Point = carViews[i].car.direction > 0 ? carViews[i].car.road.p2 : carViews[i].car.road.p1;
				carViews[i].x = scale * HMath.linearInterp(0, p1.x, 1, p2.x, carViews[i].car.progress);
				carViews[i].y = scale * HMath.linearInterp(0, p1.y, 1, p2.y, carViews[i].car.progress);
			}
			roadView.update();
		}
		
		private function drawStations():void
		{
			graphics.lineStyle(4, 0x009900);
			for (var i:int = 0; i < model.stations.length; i++)
			{
				graphics.beginFill(0, 0);
				graphics.drawRect(model.stations[i].p1.x * scale, model.stations[i].p1.y * scale - scale / 6, scale, scale / 3);
				graphics.endFill();
			}
		}
		
		private function drawRoads():void
		{
			graphics.lineStyle(2, 0);
			for (var i:int = 0; i < model.roads.length; i++)
			{
				drawRoad(model.roads[i]);
			}
			if (currentRoad)
			{
				graphics.lineStyle(4, 0x118811);
				drawRoad(currentRoad);
			}
			if (fixedRoad)
			{
				graphics.lineStyle(6, 0x1188cc);
				drawRoad(fixedRoad);
			}
		}
		
		private function drawRoad(road:Road):void
		{
			if (!road)
				return;
			graphics.moveTo(road.p1.x * scale, road.p1.y * scale);
			graphics.lineTo(road.p2.x * scale, road.p2.y * scale);
			
		}
		
		private function drawPoints():void
		{
			graphics.lineStyle(4, 0);
			for (var i:int = 0; i < model.points.length; i++)
			{
				graphics.drawCircle(model.points[i].x * scale, model.points[i].y * scale, 4);
			}
		}
		
	}
}