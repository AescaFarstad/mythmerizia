package minigames.tsp.tutorial 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import minigames.tsp.RubberInteraction;
	import util.EnterFrameEvent;
	import util.EnterFramer;
	
	public class TSPTutorial extends Sprite
	{
		private var onComplete:Function;
		private var interaction:TSPTutorialStep;
		private var view:TSPTutorialView;
		
		public function TSPTutorial() 
		{
			
		}
		
		public function load(onComplete:Function):void 
		{
			this.onComplete = onComplete;
			interaction = new TSPTutorialStep1();
			view = new TSPTutorialView();
			parent.addChild(view);
			view.load(interaction);
			
			view.planeView.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			view.planeView.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			interaction.mouseUp(e.localX, e.localY);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			interaction.mouseDown(e.localX, e.localY);
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			if (interaction)
				interaction.updateInteractable(view.planeView.mouseX, view.planeView.mouseY, e.timePassed);
			if (view)
				view.update(e.timePassed);
		}
	}

}