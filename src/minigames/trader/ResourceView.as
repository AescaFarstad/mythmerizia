package minigames.trader 
{
	import components.Label;
	import flash.display.Sprite;
	import flash.text.TextField;
	import util.layout.LayoutGroup;
	import util.layout.LayoutUtil;
	
	public class ResourceView extends Sprite
	{
		private var nameLabel:Label;
		private var countLabel:Label;
		private var bar:Sprite;
		private var group:LayoutGroup;
		
		public function ResourceView()
		{
			super();
			
			group = new LayoutGroup();
			
			bar = new Sprite();
			addChild(bar);
			
			nameLabel = new Label();
			addChild(nameLabel);
			
			countLabel = new Label();
			addChild(countLabel);
			
			group.addElement(nameLabel);
			group.addElement(bar);
		}
		
		public function load(resource:Resource):void
		{
			bar.graphics.clear();
			
			bar.graphics.beginFill(0x444444);
			bar.graphics.drawRect(0, 0, 100, 20);
			bar.graphics.endFill();
			
			bar.graphics.beginFill(0x119911);
			bar.graphics.drawRect(1, 1, 98 * resource.value / resource.cap, 18);
			bar.graphics.endFill();
			
			countLabel.text = S.format.gold(20) + resource.value.toString();
			nameLabel.text = S.format.edge(20) + resource.name;
			
			//group.arrangeInHorizontalLineWithSpacing(5);
			
			bar.x = 120;
			LayoutUtil.moveToSameHorCenter(countLabel, bar);
			
		}
		
	}
}