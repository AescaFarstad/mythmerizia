package resources
{
	public class TESettings
	{
		private var _useDynamicResources:Boolean = false;
		
		public const embeddedResourcesAvailable:Boolean = true;
		
		public const dynamicLoadingAvailable:Boolean = false;
		
		public const localeCount:int = 1;
		
		public const dynamicPath:String = "..\..\lib";
		
		
		public var localeIndex:int;
		
		
		public function TESettings()
		{
			
		}
		
		public function get useDynamicResources():Boolean 
		{
			return _useDynamicResources;
		}
		
		public function set useDynamicResources(value:Boolean):void 
		{
			if (value && !dynamicLoadingAvailable)
			{
				throw new Error("dynamic resources are not available");
			}
			if (!value && !embeddedResourcesAvailable)
			{
				throw new Error("embedded resources are not available");
			}
			_useDynamicResources = value;
		}
		
	}
}
