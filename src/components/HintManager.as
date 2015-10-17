package components 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class HintManager 
	{
		private var dict:Dictionary = new Dictionary();
		private var target:InteractiveObject;
		private var hint:BaseHint;
		private var layer:Sprite;
		private var rect:Rectangle;
		
		public function HintManager() 
		{
			
		}
		
		public function init(layer:Sprite, rect:Rectangle):void
		{
			this.rect = rect;
			this.layer = layer;			
		}
		
		public function addHint(target:InteractiveObject, hint:BaseHint):void
		{
			if (dict[target])
				removeHints(target);
			dict[target] = hint;
			target.addEventListener(MouseEvent.ROLL_OVER, onTargetRollOver);
			target.addEventListener(MouseEvent.ROLL_OUT, onTargetRollOut);
			target.addEventListener(MouseEvent.MOUSE_MOVE, onTargetMove);
			target.addEventListener(Event.REMOVED_FROM_STAGE, onTargetRemovedFromStage);
		}
		
		private function onTargetRemovedFromStage(e:Event):void 
		{
			removeHints(e.currentTarget as InteractiveObject);			
		}
		
		private function onTargetMove(e:MouseEvent):void 
		{
			if (hint)
				updateHintLocation(e.stageX, e.stageY);			
		}
		
		private function onTargetRollOut(e:MouseEvent):void 
		{
			hint.hide();
			target = null;
			hint = null;
		}
		
		private function onTargetRollOver(e:MouseEvent):void 
		{
			if (hint)
			{				
				hint.hide();
			}
			target = e.currentTarget as InteractiveObject;
			hint = dict[target];
			layer.addChild(hint);
			hint.show(target);
			updateHintLocation(e.stageX, e.stageY);
		}
		
		private function updateHintLocation(x:Number, y:Number):void 
		{
			hint.x = x + 10;
			hint.y = y - hint.height - 5;
			var location:Point = hint.localToGlobal(new Point());
			
			if (location.x + hint.width > rect.right)
				hint.x = x - hint.width - 10;
			if (location.y - hint.height + 5 < rect.top)
				hint.y = y + 5;
		}
		
		public function removeHints(target:InteractiveObject):void
		{			
			delete dict[target];
			target.removeEventListener(MouseEvent.ROLL_OVER, onTargetRollOver);
			target.removeEventListener(MouseEvent.ROLL_OUT, onTargetRollOut);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, onTargetMove);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onTargetRemovedFromStage);
			
			if (this.target == target)
				hint.hide();
		}
		
	}

}