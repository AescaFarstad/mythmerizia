package minigames.clik_or_crit.lib 
{
	import flash.utils.Dictionary;
	import minigames.clik_or_crit.model.CCModel;
	public class ActionLibrary 
	{
		
		public var list:Vector.<ActionItem> = new Vector.<ActionItem>();
		public var dict:Dictionary = new Dictionary();
		public var dict2:Dictionary = new Dictionary();
		
		public function ActionLibrary() 
		{
			add("moneyIncome", 1, function(model:CCModel, params:*, source:String, context:* = null):void 
			{
				model.money.ps.modify(params, 1, 0, source);
			});
			
			add("moneyStorage", 2, function(model:CCModel, params:*, source:String, context:* = null):void 
			{
				model.money.cap.modify(params, 1, 0, source);
			});
			
			add("priceMulti", 3, function(model:CCModel, params:*, source:String, context:* = null):void 
			{
				model.scouting.priceMulti.modify(0, (1 - params), 0, source);
			});
			
			add("timeMulti", 4, function(model:CCModel, params:*, source:String, context:* = null):void 
			{
				model.scouting.timeMulti.modify(0, (1 - params), 0, source);
			});
		}
		
		private function add(name:String, id:int, exec:Function):void
		{
			var item:ActionItem = new ActionItem(name, id, exec);
			if (dict[item.id])
				throw new Error();
			if (dict2[item.name])
				throw new Error();
			
			dict[item.id] = item;
			dict2[item.name] = item;
			list.push(item);
		}
		
		public function byID(id:int):ActionItem
		{
			return dict[id];
		}
		
		public function byName(name:String):ActionItem
		{
			return dict2[name];
		}
		
		public function exec(id:int, model:CCModel, params:*, source:String, context:* = null):void
		{
			dict[id].exec(model, params, source, context);
		}
		
	}

}