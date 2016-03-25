package minigames.clik_or_crit.view 
{
	import flash.display.Sprite;
	import minigames.clik_or_crit.model.CCModel;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	public class ScoutingScreen extends Sprite 
	{
		private var model:CCModel;
		private var mapView:MapView;
		private var resources:ResourcesPanel;
		
		public function ScoutingScreen() 
		{
			super();
			mapView = new MapView();
			addChild(mapView);
			
			resources = new ResourcesPanel();
			addChild(resources);
			
		}
		
		public function load(model:CCModel):void 
		{
			this.model = model;
			mapView.load(model);
			resources.load(model);
			
		}
		
		public function update(timePassed:int):void
		{
			resources.update(timePassed);
			mapView.update(timePassed);
		}
	}

}