package resources 
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class DispatchWrapper extends EventDispatcher
	{
		public var folder:Folder;
		
		public function DispatchWrapper(folder:Folder) 
		{
			this.folder = folder; 
			super();			
		}
		
	}	
}

