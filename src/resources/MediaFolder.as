package resources   
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class MediaFolder extends Folder
	{
		protected var __resourceMapping:Dictionary;		
		protected var __bitmapResourceEnum:Vector.<String>;
		protected var __binaryResourceEnum:Vector.<String>;
		private var __resourcesLoaded:Boolean;
		private var __foldersLoaded:Boolean;
		private var __loadindInProgress:Boolean;
		
		public function MediaFolder() { }
		
		override internal function __load():void 
		{
			if (__loadindInProgress)
			{
				trace("3:Loading already in progress! New loading rejected.", debug_name, debug_id);
				return; 
			}
			__resourcesLoaded = false;
			__foldersLoaded = false;
			__loadindInProgress = true;
			__settings.useDynamicResources ? __loadDynamicly() : __loadFromEmbeded();
			super.__load();
		}
		
		protected function __loadDynamicly():void 
		{			
			var loaderURL:URLLoader;
			var loader:Loader;
			__resourceMapping = new Dictionary();
			
			for each (var res:String in __binaryResourceEnum)
			{
				loaderURL = new URLLoader();
				loaderURL.dataFormat = URLLoaderDataFormat.BINARY;
				loaderURL.addEventListener(Event.COMPLETE, __onFileLoad);
				loaderURL.addEventListener(IOErrorEvent.IO_ERROR, __onFileError);
				
				__resourceMapping[loaderURL] = res;
				var url:String = this["__" + res + "Path"];
				loaderURL.load(new URLRequest(url));				
			}
			
			for each (res in __bitmapResourceEnum)
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __onFileLoad);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __onFileError);
				__resourceMapping[loader] = res;
				url = this["__" + res + "Path"];
				loader.load(new URLRequest(url));				
			}
		}
		
		protected function __onFileError(e:IOErrorEvent):void 
		{
			trace("3:-------------------------------------------------");
			trace("3:RESOURCE NOT LOADED! in ", debug_name, debug_id);
			trace("3:" + e.text);
			var debugType:String;
			var debugRes:String;
			if (e.target is LoaderInfo)
			{
				var info:LoaderInfo = e.target as LoaderInfo;
				debugType = "image";
				debugRes = __resourceMapping[info.loader];
			}
			if (e.target is URLLoader)
			{
				var loader:URLLoader = e.target as URLLoader;
				debugType = "binary";
				debugRes = __resourceMapping[loader];
			}
			trace("3:" + debugRes, debugType);
			
			var disp:EventDispatcher = EventDispatcher(e.target);
			disp.removeEventListener(Event.COMPLETE, __onFileLoad);
			disp.removeEventListener(IOErrorEvent.IO_ERROR, __onFileError);			
		}
		
		protected function __onFileLoad(e:Event):void 
		{	
			if (e.target is LoaderInfo)
			{
				var loader:LoaderInfo = LoaderInfo(e.target);
				loader.removeEventListener(Event.COMPLETE, __onFileLoad);		
				loader.removeEventListener(IOErrorEvent.IO_ERROR, __onFileError);
				this[__resourceMapping[loader.loader]] = Bitmap(loader.content).bitmapData;
			}
			
			if (e.target is URLLoader)
			{
				var loaderURL:URLLoader = URLLoader(e.target);
				loaderURL.removeEventListener(Event.COMPLETE, __onFileLoad);
				loaderURL.removeEventListener(IOErrorEvent.IO_ERROR, __onFileError);
				this[__resourceMapping[loaderURL]] =  ByteArray(loaderURL.data);
			}
			
			if (loader)
			{
				delete __resourceMapping[loader.loader];
			}
			if (loaderURL)
			{
				delete __resourceMapping[loaderURL];
			}
			
			for each(var key:Object in __resourceMapping) 
			{
				return;
			}			
			__onResourcesLoaded();			
		}
		
		protected function __loadFromEmbeded():void 
		{
			for each (var res:String in __bitmapResourceEnum)
			{
				this[res] = (new this["__" + res + "Class"]() as Bitmap).bitmapData;
			}
			
			for each (res in __binaryResourceEnum)
			{
				this[res] = new this["__" + res + "Class"]() as ByteArray;
			}
			__loadindInProgress = false;
			__dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override protected function __onInnerFoldersLoaded():void 
		{			
			__foldersLoaded = true;
			if (__resourcesLoaded)
			{
				__loadindInProgress = false;
				__dispatcher.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function __onResourcesLoaded():void 
		{		
			__resourcesLoaded = true;
			if (__foldersLoaded)
			{
				__loadindInProgress = false;
				__dispatcher.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}	
}
