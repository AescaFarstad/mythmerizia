package resources 
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	
	public class Folder
	{
		protected var __totalFolders:int;
		protected var __settings:TESettings;	
		protected var __innerFooldersNum:int;
		internal var __dispatcher:DispatchWrapper;
		
		public function Folder() {__dispatcher = new DispatchWrapper(this) }
		
		internal function __load():void 
		{				
			var folders:Vector.<Folder> = getInnerFolders();
			
			__totalFolders = folders.length;
			__innerFooldersNum = __totalFolders;
			if (__totalFolders == 0)
			{
				__onInnerFoldersLoaded();
				return;				
			}			
			
			for each(var folder:Folder in folders)
			{
				folder.__dispatcher.addEventListener(Event.COMPLETE, __onFolderLoaded);
				folder.__load();		
			}
		}
		
		private function __onFolderLoaded(e:Event):void 
		{
			__totalFolders--; 
			DispatchWrapper(e.target).folder.__dispatcher.removeEventListener(Event.COMPLETE, __onFolderLoaded);
			if (__totalFolders == 0)
			{
				__onInnerFoldersLoaded();
			}
		}
		
		protected function __onInnerFoldersLoaded():void 
		{
			__dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function getInnerFolders():Vector.<Folder>
		{
			var description:XML = describeType(this);
            var folders:Vector.<Folder> = new Vector.<Folder>();
            for each (var prop:XML in description.variable)
            {				
				if (this[String(prop.@name)] is Folder)
				{
					folders.push(this[String(prop.@name)] as Folder);
				}
            }
			return folders;
		}
		
		protected function propagateSettings():void 
		{
			var folders:Vector.<Folder> = getInnerFolders();
			for each(var folder:Folder in folders)
			{
				folder.__settings = __settings;	
				folder.propagateSettings();				
			}
		}
		
		protected function get debug_id():String
		{
			var id:String = getQualifiedClassName(this).split("::")[1];
			var arr:Array = id.split("_");
			
			return arr[arr.length - 1];
		}
		
		protected function get debug_name():String
		{
			var id:String = getQualifiedClassName(this).split("::")[1];
			var arr:Array = id.split("_");
			
			return arr[arr.length - 2];
		}
		
	}	
}

