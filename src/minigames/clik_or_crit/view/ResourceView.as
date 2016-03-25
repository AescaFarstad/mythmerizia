package minigames.clik_or_crit.view 
{
	import components.Label;
	import flash.display.Sprite;
	import minigames.clik_or_crit.model.CCModel;
	import minigames.rabbitHole.Resource;
	
	public class ResourceView extends Sprite 
	{
		private var model:CCModel;
		private var resource:Resource;
		public var labelValue:Label;
		public var labelCap:Label;
		public var labelPs:Label;
		public var labelName:Label;
		
		public function ResourceView() 
		{
			super();
			labelValue = new Label();
			addChild(labelValue);
			labelCap = new Label();
			addChild(labelCap);
			labelPs = new Label();
			addChild(labelPs);
			labelName = new Label();
			addChild(labelName);
		}
		
		public function load(model:CCModel, resource:Resource):void 
		{
			this.model = model;
			this.resource = resource;
			update(0);
			labelName.text = S.format.black(14) + resource.name;
		}
		
		public function update(timePassed:int):void 
		{
			labelValue.text = S.format.black(14) + resource.value.toFixed();
			labelCap.text = S.format.black(14) + resource.cap.value.toFixed() + "\\";
			labelPs.text = S.format.black(14) + "+" + resource.ps.value.toFixed() + "/s";
		}
		
	}

}