package minigames.rabbitHole.view 
{
	import flash.display.Sprite;
	import minigames.rabbitHole.Engine;
	
	public class RHView extends Sprite 
	{
		private var engine:Engine;
		private var resources:ResourcePanel;
		
		public function RHView() 
		{
			super();
			resources = new ResourcePanel();
			addChild(resources);
			resources.y = 5;
			resources.x = 5;
		}
		
		public function load(engine:Engine):void 
		{
			this.engine = engine;
			resources.load(engine);
		}
		
		public function update(timePassed:Number):void 
		{
			resources.update(timePassed);
		}
		
	}

}