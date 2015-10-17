package minigames.navgraph 
{
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import util.BaseAppFPSPanel;
	import util.DebugCellPanel;
	
	public class NavDemoView extends NavView 
	{
		private var _demo:NavDemo;
		private var dynamicShape:Shape;
		
		public function NavDemoView(model:NavSpace) 
		{
			super(model);
			var _fpsPanel:BaseAppFPSPanel = new BaseAppFPSPanel();
			addChild(_fpsPanel);
			_fpsPanel.setLayout(0, 0, 0, 0);
			_fpsPanel.show();
			dynamicShape = new Shape();
			addChild(dynamicShape);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var _locPanel:DebugCellPanel = new DebugCellPanel();
			addChild(_locPanel);
			_locPanel.setLayout(50, 0, 0, 0);
			_locPanel.show();			
		}
		
		public function set demo(value:NavDemo):void
		{
			_demo = value;
		}
		
		override public function render():void 
		{
			//return;
			super.render();
			if (!_demo)
				return;
			dynamicShape.graphics.clear();
			for (var i:int = 0; i < _demo.creepoozles.length; i++) 
			{
				dynamicShape.graphics.lineStyle(1, 0, 0);
				dynamicShape.graphics.beginFill(_demo.creepoozles[i].color, 1);
				dynamicShape.graphics.drawCircle(_demo.creepoozles[i].x * NavView.SIZE, _demo.creepoozles[i].y * NavView.SIZE, NavSpace.UNIT_SIZE * NavView.SIZE);
				dynamicShape.graphics.endFill();
				
				if (_demo.creepoozles[i].path && false)
				{
					for (var l:int = 1; l < _demo.creepoozles[i].path.length; l++) 
					{
						graphics.lineStyle(1, _demo.creepoozles[i].color, 1);
						graphics.moveTo(_demo.creepoozles[i].path[l - 1].x * SIZE, _demo.creepoozles[i].path[l - 1].y * SIZE);
						graphics.lineTo(_demo.creepoozles[i].path[l].x * SIZE, _demo.creepoozles[i].path[l].y * SIZE);
						if (l < _demo.creepoozles[i].path.length - 1)
						{/*
							var pointAlpha:Number = _demo.creepoozles[i].nextPathIndex == l ? 1 : 1;
							var thinkness:Number = _demo.creepoozles[i].nextPathIndex == l ? 4 : 2;
							var radius:Number = _demo.creepoozles[i].nextPathIndex == l ? 3 : 2;*/
							graphics.lineStyle(3, _demo.creepoozles[i].color, 1);
							graphics.drawCircle(_demo.creepoozles[i].path[l].x * SIZE, _demo.creepoozles[i].path[l].y * SIZE, 1);
						}
						/*
						if (_demo.creepoozles[i].nextIndex < _demo.creepoozles[i].targets.length - 1)
						{
							graphics.lineStyle(2, _demo.creepoozles[i].color, 1);
							var point:Point = _demo.creepoozles[i].targets[_demo.creepoozles[i].nextIndex + 1];
							graphics.drawCircle(point.x * SIZE, point.y * SIZE, 2);
						}*/
					}
				}
			}
		}
		
	}

}