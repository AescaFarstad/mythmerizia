package minigames.clik_or_crit.lib 
{
	import flash.utils.Dictionary;
	import util.Parse;
	public class BuildingLib 
	{
		public var list:Vector.<BuildingItem> = new Vector.<BuildingItem>();
		public var dict:Dictionary = new Dictionary();
		
		public function BuildingLib(source:Object) 
		{			
			var array:Array = source as Array;
			for (var i:int = 0; i < array.length; i++) 
			{
				var item:BuildingItem = new BuildingItem();
				item.id = array[i].id;
				item.pic = S.pics.cc[array[i].pic];
				item.name = array[i].name;
				item.radius = array[i].radius;
				item.time = array[i].time * 1000;
				item.action = CCLibrary.actions.byName(array[i].action.name);
				if (!item.action)
					throw new Error();
				item.actionParams = array[i].action.params;
				
				dict[item.id] = item;
				list.push(item);
			}
		}
		
		public function byID(id:int):BuildingItem
		{
			return dict[id];
		}
	}

}