package minigames.rabbitHole.view 
{
	import components.Label;
	import flash.display.Sprite;
	import minigames.rabbitHole.Engine;
	import minigames.rabbitHole.Resource;
	
	public class ResourceView extends Sprite 
	{
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
		
		public function load(engine:Engine, resource:Resource):void 
		{
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