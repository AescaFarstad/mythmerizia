package minigames.clik_or_crit.data 
{
	import flash.geom.Point;
	import minigames.clik_or_crit.data.ai.AIFactory;
	import minigames.clik_or_crit.data.ai.BaseHeroAI;
	import util.RMath;
	public class Party 
	{
		public var opponent:Party;
		public var heroes:Vector.<Hero>;
		public var isAlive:Boolean;
		public var center:Point;
		public var spread:Point;
		public var isPlayer:Boolean;
		public var model:CCModel;
		public var spawnPoints:Vector.<Point>;
		
		public function Party(model:CCModel) 
		{
			this.model = model;
			
		}
		
		public function load(source:Object, opponent:Party):void 
		{
			this.opponent = opponent;
			center = new Point(source.center.x, source.center.y);
			spread = new Point(source.spread.x, source.spread.y);
			heroes = new Vector.<Hero>();
			isAlive = true;
			
			spawnPoints = new Vector.<Point>();
			for (var j:int = 0; j < source.spawnPoints.length; j++) 
			{
				var point:Point = new Point(source.spawnPoints[j].x, source.spawnPoints[j].y);
				spawnPoints.push(point);
			}
		}
		
		public function update(timePassed:int):void 
		{
			isAlive = false;
			for (var i:int = 0; i < heroes.length; i++) 
			{
				if (heroes[i].isAlive)
				{
					isAlive = true;
					heroes[i].update(timePassed);
				}
			}
		}
		
		public function onHeroDied(hero:Hero):void 
		{
			isAlive = false;
			for (var i:int = 0; i < heroes.length; i++) 
			{
				if (heroes[i].isAlive)
				{
					isAlive = true;
					break;
				}
			}
			model.onHeroDied(this, hero);
		}
		
		public function addHero(hero:Hero):void 
		{
			isAlive = true;
			var location:Point = null;
			var distance:Number = 0;
			while (!location || distance < Hero.SIZE * Hero.SIZE * 4)
			{
				location = new Point(center.x + spread.x * (Math.random() - 0.5) * 2, center.y + spread.y * (Math.random() - 0.5) * 2);
				distance = Number.POSITIVE_INFINITY;
				for (var j:int = 0; j < heroes.length; j++) 
				{
					distance = Math.min(distance, (heroes[j].origin.x - location.x) * (heroes[j].origin.x - location.x) + 
													(heroes[j].origin.y - location.y) * (heroes[j].origin.y - location.y));
					if (distance < Hero.SIZE * Hero.SIZE * 4)
						break;
				}
			}
			var point:Point = RMath.getItem(spawnPoints);
			hero.location.x = point.x;
			hero.location.y = point.y;
			hero.origin = location;
			heroes.push(hero);
			model.onHeroAdded(hero);
		}
		
		public function interrupt():void 
		{
			for (var i:int = 0; i < heroes.length; i++) 
			{
				heroes[i].interrupt();
			}
		}
		
		public function clearAfterZone():void 
		{
			heroes = new Vector.<Hero>();
			isAlive = true;
		}
		
	}

}