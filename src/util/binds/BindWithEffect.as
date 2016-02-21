package util.binds 
{
	public class BindWithEffect extends Bind
	{
		private var _watchTarget:IBindable;
		private var _effect:Function;
		
		public function BindWithEffect(name:String, effect:Function, value:Number=0, bypassSave:Boolean = false)
		{
			_effect = effect;
			super(name, value, bypassSave);
			_value.data = _effect(this, value);
		}
		
		public function watchIBind(target:IBindable):void
		{
			_watchTarget = target;
			target.onChange.add(updateValueFromWatch);
			if (isRegistered)
				updateValueFromWatch();
			else
				_value.data = _effect(this, _watchTarget.value);
		}
		
		private function updateValueFromWatch():void
		{
			value = _watchTarget.value;
		}
		
		override public function set value(val:Number):void
		{
			val = _effect(this, val);
			super.value = val;
		}
		
		static public function EFFECT_MAX(bind:BindWithEffect, val:Number):Number
		{
			if (isNaN(val))
				val = 0;
			return Math.max(bind.value, val);
		}
		
	}
}