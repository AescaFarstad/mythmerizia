package minigames.clik_or_crit.data 
{
	import flash.utils.Dictionary;
	import minigames.clik_or_crit.data.Modifier;
	import mx.core.ButtonAsset;
	

	public class Attribute 
	{
		public var name:String;
		public var maxValue:Number;
		public var value:Number;
		public var isReplenishable:Boolean;
		public var regen:Number;
		public var diviation:Number;
		
		public var modifiers:Dictionary = new Dictionary();
		public var children:Vector.<Attribute> = new Vector.<Attribute>();
		public var updaters:Vector.<Function> = new Vector.<Function>();
		
		public function Attribute(name:String, value:Number) 
		{
			this.value = value;
			this.name = name;
			
		}
		
		public function addChild(child:Attribute, updater:Function):void 
		{
			children.push(child);
			updaters.push(updater);
			child.modify(name, 0, 0);
			updater(child.modifiers[name], child, this);
		}
		
		public function recalculate():void
		{
			var oldValue:Number = isReplenishable ? maxValue : value;
			var newValue:Number = 0;
			var multi:Number = 1;
			for each(var i:Modifier in modifiers) 
			{
				newValue+= i.add;
				multi +=i.multi;
			}
			newValue *= multi;
			if (newValue != oldValue)
			{
				if (isReplenishable)
				{
					maxValue = newValue;
				}
				else
				{
					value = newValue;
				}
				for (var j:int = 0; j < children.length; j++) 
				{
					updaters[j](children[j].modifiers[name], children[j], this);
					children[j].recalculate();
				}
			}
		}
		
		public function modify(name:String, add:Number, multi:Number):void
		{
			var modifier:Modifier = modifiers[name];
			if (!modifier)
			{				
				modifier = new Modifier(name, add, multi);
				modifiers[name] = modifier;
			}
			else
			{
				modifier.add = add;
				modifier.multi = multi;
			}
			if (add != 0 || multi != 0)
				recalculate();
		}
		
		public function replenishFully():void 
		{
			value = maxValue;
			recalculate();
		}
		
		public function get divValue():Number
		{
			return value * (1 + (Math.random() - 0.5) * diviation * 2);
		}
		
		public function update(timePassed:int):void
		{
			value+= regen * timePassed;
			value = Math.min(value, maxValue);
		}
		
		public function removeModifier(name:String):void 
		{
			var modifier:Modifier = modifiers[name];
			if (modifier)
			{
				delete modifiers[name];
				recalculate();				
			}
		}
	}

}