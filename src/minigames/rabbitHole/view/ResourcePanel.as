package minigames.rabbitHole.view 
{
	import flash.display.Sprite;
	import minigames.rabbitHole.Engine;
	import util.layout.LayoutGroup;
	
	public class ResourcePanel extends Sprite 
	{
		private var engine:Engine;
		private var views:Vector.<ResourceView> = new Vector.<ResourceView>();
		
		public function ResourcePanel() 
		{
			super();
			
		}
		
		public function load(engine:Engine):void
		{
			this.engine = engine;
			
			var groupOfGroups:LayoutGroup = new LayoutGroup();
			
			var groupValue:LayoutGroup = new LayoutGroup();
			var groupCap:LayoutGroup = new LayoutGroup();
			var groupPs:LayoutGroup = new LayoutGroup();
			var groupName:LayoutGroup = new LayoutGroup();
			
			var groupVertical:LayoutGroup = new LayoutGroup();
			
			groupOfGroups.addElement(groupName);
			groupOfGroups.addElement(groupCap);
			groupOfGroups.addElement(groupValue);
			groupOfGroups.addElement(groupPs);
			
			for (var i:int = 0; i < engine.resources.length; i++) 
			{
				var view:ResourceView = new ResourceView();
				addChild(view);
				views.push(view);
				view.load(engine, engine.resources[i]);
				groupVertical.addElement(view);
				groupValue.addElement(view.labelValue);
				groupCap.addElement(view.labelCap);
				groupPs.addElement(view.labelPs);
				groupName.addElement(view.labelName);
				
			}
			groupVertical.arrangeInVerticalLineWithSpacing(10);
			groupOfGroups.arrangeInHorizontalLineWithSpacing(20);
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < views.length; i++) 
			{
				views[i].update(timePassed);
			}
		}
		
	}

}