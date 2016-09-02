package minigames.trader 
{
	import org.osflash.signals.Signal;
	import util.RMath;
	
	public class TraderModel
	{
		public var onChange:Signal = new Signal();
		
		public var personas:Vector.<Persona>;
		public var resources:Vector.<Resource>;
		public var offers:Vector.<Offer>;
		public var offerOnHold:Offer;
		
		public var day:int;
		public var maxDay:int;
		
		public function TraderModel()
		{
			
		}
		
		public function acceptOffer(offer:Offer):void
		{
			if (!offer.isValid())
				return;
				
			offer.price.take();
			
			for (var i:int = 0; i < offer.result.length; i++)
			{
				offer.result[i].give();
			}
			passDay();
		}
		
		public function rejectOffer(offer:Offer):void
		{
			if (offer == offerOnHold)
			{
				offerOnHold = null;
			}
			else
			{			
				var index:int = offers.indexOf(offer);
				offers.splice(index, 1);				
			}
			passDay();
		}
		
		public function holdOffer(offer:Offer):void
		{
			var index:int = offers.indexOf(offer);
			offers.splice(index, 1);
			
			offerOnHold = offer;
			passDay();
		}
		
		private function addOffer():void
		{
			var offer:Offer = new Offer();
			offer.persona = RMath.getItem(personas);
			offer.daysLeft = Math.random() * 4 + 1;
			offer.price = new ResourcePack();
			offer.price.resource = RMath.getItem(resources);
			offer.price.amount = 10 + Math.random() * 90;
			
			var monetaryValue:Number = offer.price.resource.currentValue * offer.price.amount;
			monetaryValue *= 1 + ((Math.random() - 0.5) - 0.1) * 1;
			
			var numResources:int = Math.random() * 3 + 1;
			
			var usedResources:Vector.<Resource> = new Vector.<Resource>();
			usedResources.push(offer.price.resource);
			offer.result = new Vector.<ResourcePack>();
			var amounts:Vector.<Number> = new Vector.<Number>();
			amounts.push(0);
			for (var j:int = 0; j < numResources - 1; j++)
			{
				amounts.push(Math.random());
			}
			amounts.push(1);
			amounts.sort(0);
			for (var i:int = 0; i < numResources; i++)
			{
				var resource:Resource;
				while (!resource || usedResources.indexOf(resource) != -1)
					resource = RMath.getItem(resources);
				
				var pack:ResourcePack = new ResourcePack();
				pack.resource = resource;
				var thisAmount:Number = amounts[i + 1] - amounts[i];
				pack.amount = thisAmount * monetaryValue / pack.resource.currentValue;
				if (pack.amount == 0)
					pack.amount = 1;
				offer.result.push(pack);
				usedResources.push(resource);
			}
			offers.push(offer);
		}
		
		private function passDay():void
		{
			day++;
			for (var i:int = 0; i < resources.length; i++)
			{
				resources[i].progression.passDay();
			}
			if (day == maxDay)
				trace("It's over! You've earned", resources[0].value);
			else
			{
				for (var j:int = 0; j < offers.length; j++)
				{
					offers[j].passDay();
					if (offers[j].daysLeft <= 0)
					{
						offers.splice(j, 1);
						j--;
					}
				}
				
				addOffer();
				addOffer();
			}
			onChange.dispatch();
		}
		
		public function init():void
		{
			maxDay = 30;
			day = 0;
			
			offers = new Vector.<Offer>();			
			
			
			personas = new Vector.<Persona>();
			
			var persona:Persona = new Persona();
			persona.name = "сэр Клептон Джон";
			personas.push(persona);
			
			persona = new Persona();
			persona.name = "Настька-Заточка";
			personas.push(persona);
			
			persona = new Persona();
			persona.name = "анонимный конгрессмен";
			personas.push(persona);
			
			persona = new Persona();
			persona.name = "Пуэльо Кантелябро";
			personas.push(persona);
			
			persona = new Persona();
			persona.name = "Санчез Куралесио";
			personas.push(persona);
			
			persona = new Persona();
			persona.name = "сенсей Хик-итори";
			personas.push(persona);
			
			persona = new Persona();
			persona.name = "шейх Эль Шарм";
			personas.push(persona);
			
			persona = new Persona();
			persona.name = "старый Бениццио";
			personas.push(persona);
			
			persona = new Persona();
			persona.name = "Адольф Лунгрен";
			personas.push(persona);
			
			resources = new Vector.<Resource>();
			
			var resource:Resource = new Resource();
			resource.name = "Бачи";
			resource.baseValue = 10;
			resource.cap = 10000;
			resource.value = 1000;
			resource.progression = new ResourceProgression();
			resource.progression.type = 0;
			resources.push(resource);
			
			resource = new Resource();
			resource.name = "Золото";
			resource.baseValue = 50;
			resource.cap = 1000;
			resource.value = 100;
			resource.progression = new ResourceProgression();
			resource.progression.type = 1;
			resources.push(resource);
			
			resource = new Resource();
			resource.name = "Бананы";
			resource.baseValue = 3;
			resource.cap = 1000;
			resource.value = 100;
			resource.progression = new ResourceProgression();
			resource.progression.type = 2;
			resources.push(resource);
			
			resource = new Resource();
			resource.name = "Рабы";
			resource.baseValue = 15;
			resource.cap = 1000;
			resource.value = 100;
			resource.progression = new ResourceProgression();
			resource.progression.type = 3;
			resources.push(resource);
			
			resource = new Resource();
			resource.name = "Оружие";
			resource.baseValue = 25;
			resource.cap = 1000;
			resource.value = 100;
			resource.progression = new ResourceProgression();
			resource.progression.type = 4;
			resources.push(resource);
			
			for (var i:int = 0; i < 3; i++)
			{
				addOffer();
			}
			
		}
		
		public function update(timePassed:int):void
		{
			
		}
		
	}
}