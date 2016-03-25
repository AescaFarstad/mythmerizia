package minigames.clik_or_crit.view 
{
	import flash.geom.Point;
	public class ViewPortBinder 
	{
		private var from:*;
		private var to:*;
		private var vp:ViewPort;
		
		public function ViewPortBinder(from:*, to:*, vp:ViewPort) 
		{
			this.vp = vp;
			this.to = to;
			this.from = from;
			
			vp.onChange.add(update);
			update();
			
		}
		
		private function update():void 
		{
			var loc:Point = vp.gameToStage(from.x, from.y);
			to.x = loc.x;
			to.y = loc.y;
		}
		
		public function cleanUp():void
		{
			vp.onChange.remove(update);
		}
		
	}

}