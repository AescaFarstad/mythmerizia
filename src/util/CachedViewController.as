package util 
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class CachedViewController
	{
		private var _views:Dictionary = new Dictionary();
		
		private var _type:Class;
		private var _layer:Sprite;
		private var _sort:Boolean;
		
		//TODO pool
		
		/** type is ICachedView*/
		public function CachedViewController(type:Class, layer:Sprite)
		{
			this._sort = sort;
			_renderInfo = renderInfo;
			_layer = layer;
			_type = type;
		}
		
		public function update(state:WorldState, vec:*):void
		{
			for (var i:int = 0; i < vec.length; i++)
			{
				if (!_views[vec[i].id])
				{
					_views[vec[i].id] = new _type();
					_views[vec[i].id].load(vec[i], _renderInfo);
					_layer.addChild(_views[vec[i].id]);
				}
				_views[vec[i].id].update(state);
				if (_sort)
					_layer.setChildIndex(_views[vec[i].id], i);
			}
			
			for (var key:* in _views)
			{
				if (_views[key].timeStamp != state.timeManager.gameTime)
				{
					if (state.gameState.clientLogger.hasDeath(key))
					{
						if (!_views[key].isReadyToDie())
						{
							_views[key].prepareToDie(state);
							continue;
						}
					}
					_views[key].clear();
					_layer.removeChild(_views[key]);
					delete _views[key];
				}
			}
		}
		
		public function clear():void
		{
			for (var key:* in _views)
			{
				_views[key].clear();
				_layer.removeChild(_views[key]);
				delete _views[key];
			}
		}
		
		public function getView(id:Number):*
		{
			return _views[id];
		}
	}
}