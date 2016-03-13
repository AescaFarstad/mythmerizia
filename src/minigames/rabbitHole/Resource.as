package minigames.rabbitHole 
{
	import util.binds.Bind;
	import util.binds.Parameter;
	
	public class Resource extends Bind
	{
		public var cap:Parameter;
		public var ps:Parameter;
		
		public function Resource(name:String)
		{
			super(name);
			cap = new Parameter(name + "Cap");
			ps = new Parameter(name + "Ps");			
		}
		
		
		
		public function update(timePassed:int):void
		{
			var newValue:Number = _value + timePassed * ps.value / 1000;
			newValue = Math.min(newValue, cap.value);
			newValue = Math.max(newValue, 0);
			value = newValue;
		}
		
		public function load(source:Object):void 
		{
			if (source.cap)
				cap.modify(source.cap);
			if (source.ps)
				ps.modify(source.ps);
			if (source.value)
				value = source.value;
			value = _value;
		}
		
	}
}