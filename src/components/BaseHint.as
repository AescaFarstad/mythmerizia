package components 
{
	import flash.display.Sprite;
	import minigames.tsp.solvers.ITSPSolver;
	
	
	public class BaseHint extends Sprite 
	{
		
		public function BaseHint() 
		{
				
		}
		
		public function show(target:*):void
		{
			
		}
		
		public function hide():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
		protected function drawBack():void
		{
			var padding:int = 5;
			graphics.clear();
			graphics.beginFill(0xe7e7e7);
			graphics.drawRect( -padding, -padding, width + padding * 2, height + padding * 2);
			graphics.endFill();
		}
	}

}