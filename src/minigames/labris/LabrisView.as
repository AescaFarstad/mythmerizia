package minigames.labris 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class LabrisView extends Sprite 
	{
		public const scale:Number = 8;
		
		private var model:LabrisModel;
		
		private var g:Graphics;
		
		public function LabrisView() 
		{
			super();
			g = graphics;
		}
		
		public function load(model:LabrisModel):void 
		{
			this.model = model;
			render();
		}
		
		public function update(timePassed:int):void 
		{
			if (model.isChanged)
				render();
		}
		
		private function render():void 
		{
			g.clear();
			for (var i:int = 0; i < model.cells.length; i++) 
			{
				for (var j:int = 0; j < model.cells[i].length; j++) 
				{
					if (model.cells[i][j].isObstacle)
					{
						g.beginFill(0xe7e7e7);
						g.drawRect(i * scale, j * scale, scale, scale);
						g.endFill();						
					}
				}
			}
			
		}
		
	}

}