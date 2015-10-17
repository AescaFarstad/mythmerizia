package minigames.clik_or_crit.view 
{
	import components.BaseHint;
	import components.Label;
	import minigames.clik_or_crit.data.GearItem;
	
	
	public class GearItemHint extends BaseHint 
	{
		private var itemView:GearItemView;
		private var item:GearItem;
		
		private var labels:Vector.<Label> = new Vector.<Label>();
		static private var _instance:GearItemHint;
		
		static public function get instance():GearItemHint 
		{
			if (!_instance)
				_instance = new GearItemHint();
			return _instance;
		}
		
		override public function show(target:*):void 
		{
			itemView = target as GearItemView;
			item = itemView.item;
			if (!item)
				return;
			var dy:int = 0;
			var by:int = 35;
			
			for (var i:int = 0; i < item.stats.length; i++) 
			{
				var label:Label = new Label();
				addChild(label);
				label.y = dy;
				dy += by;
				label.text = S.format.edge(15) + item.stats[i].attribute + " " + (item.stats[i].divider > 0 ? "+" : "") + 
						(itemView.slot.getStatEffectOnThisLevel(item.stats[i]) * 100).toFixed() + "%";
				labels.push(label);
			}
			drawBack();
		}
		
		override public function hide():void 
		{
			super.hide();
			for (var i:int = 0; i < labels.length; i++) 
			{
				labels[i].kill();
			}
		}
		
	}

}