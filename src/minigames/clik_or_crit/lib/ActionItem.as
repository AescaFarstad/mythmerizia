package minigames.clik_or_crit.lib 
{
	import minigames.clik_or_crit.model.CCModel;
	public class ActionItem 
	{
		public var name:String;
		public var id:int;
		public var execF:Function;
		
		public function ActionItem(name:String, id:int, execF:Function) 
		{
			this.execF = execF;
			this.id = id;
			this.name = name;			
		}
		
		public function exec(model:CCModel, params:*, source:String, context:* = null):void
		{
			execF(model, params, source, context);
		}
	}

}