package minigames.clik_or_crit.view 
{
	import flash.display.Sprite;
	import minigames.clik_or_crit.data.IWorldListener;
	import minigames.clik_or_crit.data.World;
	import minigames.clik_or_crit.IInputListener;
	import util.ImageButton;
	
	

	public class NavPanel extends Sprite implements IWorldListener
	{/*
		[Embed(source = "../disabledNav.png")]
		private static var disabledPic:Class;
		[Embed(source = "../downNav.png")]
		private static var downPic:Class;
		[Embed(source = "../idleNav.png")]
		private static var idlePic:Class;
		[Embed(source="../overNav.png")]
		private static var overPic:Class;*/
		
		private var currentIndex:int;
		
		private var prevButton:ImageButton;
		private var currentButton:ImageButton;
		private var nextButton:ImageButton;
		private var world:World;
		private var mainView:CCView;
		
		public function NavPanel() 
		{
			/*var images:Object = {
				idle:new idlePic().bitmapData,
				down:new downPic().bitmapData,
				over:new overPic().bitmapData,
				disabled:new disabledPic().bitmapData };*/
				
			prevButton = new ImageButton(S.pics.clickOrCrit.buttons.navPanelButton, onPrevClick, (currentIndex - 1).toString());
			addChild(prevButton);
			currentButton = new ImageButton(S.pics.clickOrCrit.buttons.navPanelButton, null, (currentIndex).toString());
			addChild(currentButton);
			nextButton = new ImageButton(S.pics.clickOrCrit.buttons.navPanelButton, onNextClick, (currentIndex + 1).toString());
			addChild(nextButton);
			
			var margin:int = 20;
			
			currentButton.x = prevButton.width + margin;
			nextButton.x = currentButton.x + currentButton.width + margin;
			
			graphics.lineStyle(2, 0);
			graphics.moveTo(prevButton.width, prevButton.height / 2);
			graphics.lineTo(currentButton.x, currentButton.height / 2);
			
			graphics.moveTo(currentButton.x + currentButton.width, currentButton.height / 2);
			graphics.lineTo(nextButton.x, nextButton.height / 2);
			
			graphics.moveTo(currentButton.x - 5, currentButton.height + 4);
			graphics.lineTo(currentButton.x + currentButton.width + 5, currentButton.height + 4);			
		}
		
		private function onNextClick(...params):void 
		{
			if (world.nextZoneAvailable && mainView.inputListener)
				mainView.inputListener.onNextZone();
		}
		
		private function onPrevClick(...params):void 
		{
			if (world.prevZoneAvailable && mainView.inputListener)
				mainView.inputListener.onPrevZone();
		}
		
		public function load(world:World, mainView:CCView):void 
		{
			this.mainView = mainView;
			this.world = world;
			world.listener = this;
			render();
		}
		
		public function onZonePassed():void 
		{
			render();
		}
		
		public function onZoneChanged():void 
		{
			render();
		}
		
		private function render():void 
		{
			prevButton.visible = world.prevZoneAvailable;
			nextButton.enabled = world.nextZoneAvailable;
			
			if (world.prevZoneAvailable)
				prevButton.text = S.format.main(20) + world.previousZone.name;
			currentButton.text = S.format.main(20) + world.currentZone.name;
			nextButton.text = S.format.main(20) + world.nextZone.name;
			
		}
		
	}

}