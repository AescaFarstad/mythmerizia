package minigames.clik_or_crit.data 
{
	import flash.events.DataEvent;
	

	public class Divine 
	{
		[Embed(source="../../../../lib/click or crit/divine.json", mimeType="application/octet-stream")]
		private static var data:Class;
		
		private var source:Object;
		public var damage:Attribute;
		public var heal:Attribute;
		
		public var gold:Resource;
		public var resources:Vector.<Resource>;
		
		public function Divine() 
		{
			source = JSON.parse(new data());
			damage = new Attribute("damage", source.damage);
			heal = new Attribute("heal", source.heal);
			
			resources = new Vector.<Resource>();
			
			gold = new Resource("gold", 0);
			resources.push(gold);
			
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < resources.length; i++) 
			{
				resources[i].update(timePassed);
			}
		}
	}

}