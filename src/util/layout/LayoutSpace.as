package util.layout 
{
	/**
	 *  Задумано для использования в качестве "виртуального" объекта, относительно котого можно будет
	 * раполагать другие объекты, используя утилиты LayoutUtil и MeasureUtil
	 */
	
	public final class LayoutSpace implements IBaseMeasurable, IBaseResizable 
	{
		public var x:int;
		public var y:int;
		private var _width:int;
		private var _height:int;
		
		public function LayoutSpace() 
		{
		}
		
		public function set baseWidth(value:int):void 
		{
			_width = value;
		}
		
		public function set baseHeight(value:int):void 
		{
			_height = value;
		}
		
		public function get baseWidth():int 
		{
			return _width;
		}
		
		public function get baseHeight():int 
		{
			return _height;
		}
	}
}