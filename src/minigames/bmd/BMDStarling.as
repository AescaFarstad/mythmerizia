package minigames.bmd 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	public class BMDStarling extends Sprite
	{
		static public var instance:BMDStarling;
		static public var onNewInstance:EventDispatcher = new EventDispatcher();
		
		private var model:BMDModel;
		private var scale:Number = 20;
		
		public function BMDStarling()
		{
			instance = this;
			onNewInstance.dispatchEvent(new Event(Event.ADDED));
			
			var atlas:TextureAtlas = new AtlasFactory().create();
		}
		
		public function load(model:BMDModel):void
		{
			this.model = model;
			//addEventListener(MouseEvent.CLICK, onClick);
		}
		
		
		public function update(timePassed:int):void
		{
			render();
		}
		/*
		private function render():void
		{
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, model.sizeX * scale, model.sizeY * scale);
			graphics.endFill();
			for (var i:int = 0; i < model.cells.length; i++)
			{
				for (var j:int = 0; j < model.cells[i].length; j++)
				{
					if (model.cells[i][j].isObstacle)
					{
						graphics.beginFill(0xe0e0e0);
						graphics.drawRect(i * scale, j * scale, scale, scale);
						graphics.endFill();
					}
				}
			}
			
			for (var k:int = 0; k < model.actors.length; k++)
			{
				if (model.actors[k] is Ball)
				{
					graphics.beginFill(0x88ff88);
					graphics.drawCircle(model.actors[k].x * scale, model.actors[k].y * scale, (model.actors[k] as Ball).size * scale);
					graphics.endFill();
				}
				
				if (model.actors[k] is ShooterBuilding)
				{
					graphics.beginFill(0xff4444);
					graphics.drawRoundRect(model.actors[k].x * scale, model.actors[k].y * scale, scale, scale, 0.2 * scale, 0.2 * scale);
					graphics.endFill();
				}
			}
		}*/
	}
}