package minigames.clik_or_crit.view 
{
	import flash.display.Sprite;
	import minigames.clik_or_crit.model.CCModel;
	import minigames.rabbitHole.Engine;
	import util.layout.LayoutGroup;
	
	public class ResourcesPanel extends Sprite 
	{
		private var views:Vector.<ResourceView> = new Vector.<ResourceView>();
		private var model:CCModel;
		
		public function ResourcesPanel() 
		{
			super();			
		}
		
		public function load(model:CCModel):void
		{
			this.model = model;
			
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
			
			for (var i:int = 0; i < model.resources.length; i++) 
			{
				var view:ResourceView = new ResourceView();
				addChild(view);
				views.push(view);
				view.load(model, model.resources[i]);
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