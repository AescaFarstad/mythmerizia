package minigames.clik_or_crit.view 
{
	import engine.SimpleUpdatable;
	import engine.Updater;
	import flash.display.Sprite;
	import minigames.clik_or_crit.model.CCModel;
	import ui.ProgressBar;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	import util.layout.LayoutUtil;
	
	public class ScoutingScreen extends Sprite 
	{
		private var model:CCModel;
		private var mapView:MapView;
		private var resources:ResourcesPanel;
		
		private var updater:Updater = new Updater();
		
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
			
			model.scouting.scoutProcess.onStarted.add(onScoutingStarted);			
			model.scouting.buildingProcess.onStarted.add(onBuildingStarted);			
		}
		
		private function onBuildingStarted():void 
		{
			var pb:ProgressBar = new ProgressBar();
			pb.init(160, 30, 0, 1, 0x774411, 0x998833, getBuildingText);
			addChild(pb);
			model.scouting.buildingProcess.onCompleted.addOnce(onComplete);
			
			LayoutUtil.moveToSameBottom(pb, { y:0, height:stage.stageHeight }, -10);
			LayoutUtil.moveToSameLeft(pb, { x:180 }, 10);
			
			var updatable:SimpleUpdatable = new SimpleUpdatable();
			updatable.load(updatePb, onComplete);
			updater.push(updatable);
			
			function onComplete():void
			{
				model.scouting.buildingProcess.onCompleted.remove(onComplete);				
				removeChild(pb);
				updater.remove(updatable);
			}
			
			function updatePb():void
			{
				pb.setValue(model.scouting.buildingProcess.ratio);
			}
			
			function getBuildingText(ratio:Number):String
			{
				return S.format.white(18) + model.scouting.buildingProcess.building.name + " " + (ratio * 100).toFixed() + "%";
			}
		}
		
		private function onScoutingStarted():void 
		{
			var pb:ProgressBar = new ProgressBar();
			pb.init(160, 30, 0, 1, 0x112299, 0x7799ff, getScoutingText);
			addChild(pb);
			model.scouting.scoutProcess.onCompleted.addOnce(onComplete);
			
			LayoutUtil.moveToSameBottom(pb, { y:0, height:stage.stageHeight }, -10);
			LayoutUtil.moveToSameLeft(pb, { x:0 }, 10);
			
			var updatable:SimpleUpdatable = new SimpleUpdatable();
			updatable.load(updatePb, onComplete);
			updater.push(updatable);
			
			function onComplete():void
			{
				model.scouting.scoutProcess.onCompleted.remove(onComplete);				
				removeChild(pb);
				updater.remove(updatable);
			}
			
			function updatePb():void
			{
				pb.setValue(model.scouting.scoutProcess.ratio);
			}
		}
		
		public function getScoutingText(ratio:Number):String
		{
			return S.format.white(18) + "Scouting " + (ratio * 100).toFixed() + "%";
		}
		
		public function update(timePassed:int):void
		{
			resources.update(timePassed);
			mapView.update(timePassed);
			updater.update(timePassed);
		}
	}

}