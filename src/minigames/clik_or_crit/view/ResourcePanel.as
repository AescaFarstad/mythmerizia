package minigames.clik_or_crit.view 
{
	import components.Label;
	import components.Table;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import minigames.clik_or_crit.data.CCModel;
	
	

	public class ResourcePanel extends Sprite 
	{
		private var model:CCModel;
		private var table:Table;
		private var resLabels:Vector.<Label>;
		
		public function ResourcePanel() 
		{
			
		}
		
		public function load(model:CCModel):void
		{
			this.model = model;
			resLabels = new Vector.<Label>();
			var content:Vector.<Vector.<DisplayObject>> = new Vector.<Vector.<DisplayObject>>();
			var titles:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var values:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			content.push(titles);
			content.push(values);
			var dimX:Vector.<Number> = new Vector.<Number>();
			dimX.push(-1);
			dimX.push(40);
			for (var i:int = 0; i < model.divine.resources.length; i++) 
			{
				var label:Label = new Label();
				label.text = S.format.edge(14) + model.divine.resources[i].name;
				titles.push(label);
				
				label = new Label();
				label.text = S.format.edge(14) + model.divine.resources[i].value.toFixed();
				values.push(label);
				resLabels.push(label);
			}
			
			table = new Table();
			table.setup(25, 1, 2, 3);
			table.load(content, dimX);			
			addChild(table);
			table.paint(0, 0.1, 0, 0, 0, 0.1);
		}
		
		public function update(timePassed:int):void 
		{
			for (var i:int = 0; i < model.divine.resources.length; i++) 
			{
				resLabels[i].text = S.format.edge(12) + model.divine.resources[i].value.toFixed();
			}
		}
		
	}

}