package minigames.rabbitHole 
{
	import util.binds.BindManager;
	public class Engine
	{
		public var isLoading:Boolean;
		public var bindManager:BindManager = new BindManager();
		
		public var resources:Vector.<Resource> = new Vector.<Resource>();
		public function Engine()
		{
			
		}
		
		public function handleOfflineProgression(timePassed:Number):void
		{
			
		}
		
		public function loadResource(object:Object):void 
		{
			var res:Resource = new Resource(object.name);
			bindManager.registerBind(res);
			res.load(object);
			resources.push(res);
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < resources.length; i++) 
			{
				resources[i].update(timePassed);
			}
		}
		
		public function postInit():void 
		{
			
		}
	}
}