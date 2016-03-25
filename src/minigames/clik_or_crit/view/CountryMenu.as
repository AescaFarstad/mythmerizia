package minigames.clik_or_crit.view 
{
	import components.GrayTextButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import minigames.clik_or_crit.model.CCModel;
	import minigames.clik_or_crit.model.Country;
	import util.layout.LayoutGroup;
	
	public class CountryMenu extends Sprite 
	{
		private var country:Country;
		private var model:CCModel;
		private var vp:ViewPort;
		
		private var buttons:Vector.<GrayTextButton> = new Vector.<GrayTextButton>();
		private var buttonGroup:LayoutGroup = new LayoutGroup();
		
		public function CountryMenu() 
		{
			super();
			
			addButton(new GrayTextButton(200, 30, "Build", "white", 20, onBuildClick));
			addButton(new GrayTextButton(200, 30, "Scout inwards", "white", 20, onScoutInCLick));
			addButton(new GrayTextButton(200, 30, "Scout outwards", "white", 20, onScoutOutCLick));
			
			buttonGroup.arrangeInVerticalLineWithSpacing(5);
		}
		
		private function onBuildClick(...param):void 
		{
			
		}
		
		private function onScoutInCLick(...param):void 
		{			
			model.scoutIn();
			hide();
		}
		
		private function onScoutOutCLick(...param):void 
		{
			model.scoutOut();
			hide();
		}
		
		private function addButton(button:GrayTextButton):void
		{
			addChild(button);
			buttons.push(button);
			buttonGroup.addElement(button);			
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
		}
		
		public function load(model:CCModel, vp:ViewPort):void 
		{
			this.vp = vp;
			this.model = model;
			
		}
		
	}

}