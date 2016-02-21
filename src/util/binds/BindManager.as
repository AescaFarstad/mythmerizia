package util.binds
{
	import flash.utils.Dictionary;
	public class BindManager
	{
		public var bindByName:Dictionary = new Dictionary();
		public var list:Vector.<Bind> = new Vector.<Bind>();
		
		public function BindManager()
		{
		}
		
		public function registerBind(bind:Bind):void
		{
			if (bindByName[bind.name] != undefined)
				throw new Error("Overwriting existing bind, " + bind.name);
			bind.isRegistered = true;
			bindByName[bind.name] = bind;
			list.push(bind);
		}
		
		public function saveBinds():Object
		{
			var binds:Object = new Object();
			var bind:Bind;
			for (var k:String in bindByName)
			{
				bind = bindByName[k];
				if (bind.bypassSave)
					continue;
				binds[k] = bind.value;
			}
			return binds;
		}
		
		public function loadBinds(source:Object):void
		{
			for (var key:String in source)
			{
				if (bindByName[key])
					bindByName[key].value = source[key];
				else
					trace("Save file has bind which the game doesn't have: " + key);
			}
		}
	}
}