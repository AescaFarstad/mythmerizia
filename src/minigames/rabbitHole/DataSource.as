package minigames.rabbitHole 
{
	public class DataSource
	{
		[Embed(source = "data/resources.json", mimeType = "application/octet-stream")]
		static private var ResourceData:Class;
		
		static public function initEngine(engine:Engine):void
		{			
			var resourceData:Object = JSON.parse(new ResourceData());
			for (var i:int = 0; i < resourceData.length; i++) 
			{
				engine.loadResource(resourceData[i]);
			}
			engine.postInit();
		}
		
		static public function loadSave(engine:Engine, save:Object):void
		{
			trace("load save")
			engine.isLoading = true;
			
			engine.bindManager.loadBinds(save.binds);
			
			engine.isLoading = false;
			engine.handleOfflineProgression(save.saveTime);
		}
		
		static public function createSave(engine:Engine):Object
		{
			var result:Object = { };
			var binds:Object = engine.bindManager.saveBinds(); 
			
			result.binds = binds;
			
			result.saveTime = new Date().time;
			return result;
		}
		
		/*
		 * Требует вектор <ISaveLoadable>
		 */ 
		static private function vectorToObjects(vec:*, debugInfo:String = null):Vector.<Object>
		{
			var items:Vector.<Object> = new Vector.<Object>();
			for (var i:int = 0; i < vec.length; i++)
			{
				if (!(vec[i] is ISaveLoadable))
					throw new Error("Type check failed. The item must be of type ISaveLoadable " + debugInfo);
				items.push(vec[i].saveToObject(false));
			}
			return items;
		}
		
		///source - Vector.<Object> or Array
		static private function objectsToVector(vec:*, source:*, debugInfo:String = null):void
		{
			if (vec.length > 0 && !(vec[0] is ISaveLoadable))
				throw new Error("Type check failed. The item must be of type ISaveLoadable " + debugInfo);
			for (var j:int = 0; j < source.length; j++)
			{
				var id:int = source[j].id;
				for (var k:int = 0; k < vec.length; k++)
				{					
					if (vec[k].id == id)
					{						
						vec[k].loadFromObject(source[j]);
						break;
					}
				}
				if (k == vec.length)
					trace("Missing item from save file id: " + id + " " + debugInfo);
			}
		}
		
	}
}