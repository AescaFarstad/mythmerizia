package minigames.roads 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	import util.binds.Bind;
	import util.binds.BindManager;
	import util.RMath;
	
	public class RoadsModel
	{
		[Embed(source = "data.json", mimeType = "application/octet-stream")]
		private var DATA:Class;
		
		private var MAX_X:int = 1000;
		
		public var points:Vector.<Point>;
		public var pointByHash:Dictionary;
		
		public var stations:Vector.<Station>;
		public var roads:Vector.<Road>;
		public var cars:Vector.<Car>;
		
		public var onCarSpawned:Signal = new Signal(Car);
		public var onCarExit:Signal = new Signal(Car);
		
		public var backtrackAwareness:Number = 0.9;
		
		public var money:Bind = new Bind("money");
		public var bindManager:BindManager = new BindManager();
		
		public var upgradesPurchased:int;
		public var upSpeedPurchased:int;
		public var upCapacityPurchased:int;
		
		public function RoadsModel()
		{
			bindManager.registerBind(money);
		}
		
		public function init():void
		{
			var data:Object = JSON.parse(new DATA().toString());
			
			pointByHash = new Dictionary();
			points = new Vector.<Point>();
			cars = new Vector.<Car>();
			
			stations = new Vector.<Station>();
			for (var i:int = 0; i < data.stations.length; i++)
			{
				stations.push(new Station(
						getPoint(data.stations[i].x, data.stations[i].y), 
						getPoint(data.stations[i].x + 1, data.stations[i].y), 
						data.stations[i].stage, i));
			}
			
			roads = new Vector.<Road>();
			for (i = 0; i < data.roads.length; i++)
			{
				roads.push(new Road(
						getPoint(data.roads[i].x1, data.roads[i].y1), 
						getPoint(data.roads[i].x2, data.roads[i].y2)));
				roads[i].capacity = 5;
			}
			money.value = 150;
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < cars.length; i++)
			{
				cars[i].progress += timePassed * cars[i].road.getSpeed();
				if (cars[i].progress > 1)
				{
					cars[i].road.numCars--;
					cars[i].progress = 0;
					var endPoint:Point = cars[i].direction > 0 ? cars[i].road.p2 : cars[i].road.p1;
					if (getStationByPoint(endPoint) == cars[i].target)
					{
						onCarExit.dispatch(cars[i]);
						money.value += 20;
						cars.splice(i, 1);
						i--;
						continue;
					}
					var options:Vector.<Road> = getRoadsFrom(endPoint);
					for (var j:int = 0; j < options.length; j++)
					{
						if (options[j].numCars >= int(options[j].getResultingCapacity()))
						{
							options.splice(j, 1);
							j--;
						}
							
					}
					if (options.length > 1 && Math.random() < backtrackAwareness)
					{
						options.splice(options.indexOf(cars[i].road), 1);
					}
					cars[i].road = RMath.getItem(options);
					cars[i].road.numCars++;
					cars[i].direction = (cars[i].road.p1 == endPoint ? 1 : -1);
				}
			}
			for (var k:int = 0; k < roads.length; k++)
			{
				roads[k].update(timePassed);
			}
		}
		
		private function getStationByPoint(endPoint:Point):Station
		{
			for (var i:int = 0; i < stations.length; i++)
			{
				if (stations[i].p1 == endPoint || stations[i].p2 == endPoint)
					return stations[i];
			}
			return null;
		}
		
		public function sendCar(station:Station):void
		{
			var price:int = 15;
			if (money.value < price)
				return;
			var options:Vector.<Road> = getRoadsFrom(station.p2);
			if (options[0].capacity <= options[0].numCars)
				return;
			
			money.value -= price;
				
			var car :Car = new Car();
			cars.push(car);
			car.progress = 0;
			
			car.road = options[0];
			car.road.numCars++;
			car.direction = (options[0].p1 == station.p2 ? 1 : -1);
			car.target = getRandomNextStation(station.stage);
			
			onCarSpawned.dispatch(car);
		}
		
		private function getRandomNextStation(stage:int):Station
		{
			var options:Vector.<Station> = new Vector.<Station>();
			for (var i:int = 0; i < stations.length; i++)
			{
				if (stations[i].stage == stage + 1)
					options.push(stations[i]);
			}
			return RMath.getItem(options);
		}
		
		private function getPoint(x:Number, y:Number):Point
		{
			var hash:int = x + y * MAX_X;
			if (pointByHash[hash])			
				return pointByHash[hash];
			else
			{
				var p:Point = new Point(x, y);
				pointByHash[hash] = p;
				points.push(p);
				return p;
			}
		}
		
		public function getRoadsFrom(point:Point):Vector.<Road>
		{
			var result:Vector.<Road> = new Vector.<Road>();
			for (var i:int = 0; i < roads.length; i++)
			{
				if (roads[i].p1 == point || roads[i].p2 == point)
					result.push(roads[i]);
			}
			return result;
		}
		
		public function upgradeSpeed(road:Road):void
		{
			var price:Number = getUpSpeedPrice(road);
			if (price > money.value)
				return;
				
			road.numCapacityInc++;
			upgradesPurchased++;
			upSpeedPurchased++;
			road.maxVelocity += 1 / 2 / 1000 / 5;
			money.value -= price;
		}
		
		public function upgradeCapacity(road:Road):void
		{
			var price:Number = getUpCapacityPrice(road);
			if (price > money.value)
				return;
			
			road.numSpeedInc++;
			upgradesPurchased++;
			upCapacityPurchased++;
			road.capacity += 1;
			money.value -= price;
		}
		
		public function getUpCapacityPrice(road:Road):Number
		{
			return Math.floor(10 * Math.pow(1.2, road.numCapacityInc) + upgradesPurchased + Math.pow(upCapacityPurchased * 2, 1.5));
		}
		
		public function getUpSpeedPrice(road:Road):Number
		{
			return Math.floor(10 * Math.pow(1.2, road.numSpeedInc) + upgradesPurchased + Math.pow(upSpeedPurchased * 2, 1.5));
		}
		
	}
}