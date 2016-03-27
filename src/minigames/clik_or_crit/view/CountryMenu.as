package minigames.clik_or_crit.view 
{
	import components.GrayTextButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import minigames.clik_or_crit.lib.CCLibrary;
	import minigames.clik_or_crit.model.CCModel;
	import minigames.clik_or_crit.model.Country;
	import util.layout.LayoutGroup;
	
	public class CountryMenu extends Sprite 
	{
		private var country:Country;
		private var model:CCModel;
		private var vp:ViewPort;
		
		private var buttons:Vector.<GrayTextButton> = new Vector.<GrayTextButton>();
		private var buttonsBuild:Vector.<GrayTextButton> = new Vector.<GrayTextButton>();
		private var buttonGroup:LayoutGroup = new LayoutGroup();
		private var buttonBuildGroup:LayoutGroup = new LayoutGroup();
		
		private var general:Sprite;
		private var build:Sprite;
		
		public function CountryMenu() 
		{
			super();
			
			general = new Sprite();
			addChild(general);
			
			build = new Sprite();
			addChild(build);
			
			addButton(new GrayTextButton(300, 30, "Build", "white", 20, onBuildClick));
			addButton(new GrayTextButton(300, 30, "Scout inwards", "white", 20, onScoutInClick));
			addButton(new GrayTextButton(300, 30, "Scout outwards", "white", 20, onScoutOutClick));
			
			buttonGroup.arrangeInVerticalLineWithSpacing(5);
			
			for (var i:int = 0; i < CCLibrary.buildings.list.length; i++) 
			{
				addBuildButton(new GrayTextButton(200, 30, CCLibrary.buildings.list[i].name, "white", 18, getBuildClickFunction(i)));
			}
			
			buttonBuildGroup.arrangeInVerticalLineWithSpacing(5);
			
		}
		
		private function getBuildClickFunction(index:int):Function 
		{
			return function(...params):void { model.input.tryToBuild(CCLibrary.buildings.list[index], country); hide(); };
		}
		
		private function onBuildClick(...param):void 
		{
			general.visible = false;
			build.visible = true;
			
			for (var i:int = 0; i < CCLibrary.buildings.list.length; i++) 
			{
				buttonsBuild[i].enabled = model.scouting.canBuild(CCLibrary.buildings.list[i], country);
			}
		}
		
		private function onScoutInClick(...param):void 
		{			
			model.input.scoutIn();
			hide();
		}
		
		private function onScoutOutClick(...param):void 
		{
			model.input.scoutOut();
			hide();
		}
		
		private function addButton(button:GrayTextButton):void
		{
			general.addChild(button);
			buttons.push(button);
			buttonGroup.addElement(button);			
		}
		
		private function addBuildButton(button:GrayTextButton):void
		{
			build.addChild(button);
			buttonsBuild.push(button);
			buttonBuildGroup.addElement(button);			
		}
		
		public function hide():void 
		{
			visible = false;
		}
		
		public function show(country:Country):void 
		{
			this.country = country;
			var loc:Point = vp.gameToStage(country.x, country.y);
			x = loc.x;
			y = loc.y;
			visible = true;
			buttons[1].text = "Scout inwards  | " + model.scouting.scoutInPrice.value + "$";
			buttons[2].text = "Scout outwards | " + model.scouting.scoutOutPrice.value + "$";
			
			buttons[0].enabled = country.building == null && model.scouting.buildingProcess.isComplete;
			buttons[1].enabled = model.scouting.scoutProcess.isComplete;
			buttons[2].enabled = model.scouting.scoutProcess.isComplete;
			
			general.visible = true;
			build.visible = false;
		}
		
		public function load(model:CCModel, vp:ViewPort):void 
		{
			this.vp = vp;
			this.model = model;
			
		}
		
	}

}