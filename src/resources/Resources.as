package resources
{	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	public class Resources extends Folder implements IEventDispatcher
	{
		public var text:r_text_c2f11b = new r_text_c2f11b();
		
		public function Resources() 
		{
			__settings = new TESettings(); propagateSettings(); 
		}
			
		
		public function loadResources():void
		{
			if (__settings.dynamicLoadingAvailable || __settings.embeddedResourcesAvailable)
			{
				__load();
			}
			else
			{
				trace("Neither dynamic nor embedded resources are available. Nothing is loaded.");
			}
		}
			
		public function get settings():TESettings { return __settings; }	
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			__dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return __dispatcher.dispatchEvent(event);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			return __dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return __dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return __dispatcher.willTrigger(type);
		}
	}
}
