package minigames.labris 
{
	import flash.display.Sprite;
	import util.BaseAppFPSPanel;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	public class LabrisMain extends Sprite 
	{
		private var model:LabrisModel;
		private var view:LabrisView;
		
		public function LabrisMain() 
		{
			super();
			model = new LabrisModel();
			view = new LabrisView();
			addChild(view);
			view.load(model);
			
			EnterFramer.addEnterFrameUpdate(onFrame);
			
			var fps:BaseAppFPSPanel = new BaseAppFPSPanel();
			
			addChild(fps);
			fps.setLayout(0, 0, 30, 20);
			fps.show();
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			model.update(e.timePassed);
			view.update(e.timePassed);
		}
		
	}

}