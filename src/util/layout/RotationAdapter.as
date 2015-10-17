package util.layout 
{
	import com.playflock.game.utils.layout.IBaseMeasurable;
	import com.playflock.game.utils.layout.IBaseResizable;
	import com.playflock.game.utils.layout.LayoutUtil;
	import com.playflock.util.interfaces.ILayoutable;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	

	public class RotationAdapter extends Sprite implements ILayoutable, IBaseMeasurable, IBaseResizable 
	{
		private var _baseWidth:int;
		private var _baseHeight:int;
		private var _state:AdapterState;
		public var child:DisplayObject;
		
		public function RotationAdapter(child:DisplayObject) 
		{
			AdapterState.init();
			this.child = child;
			addChild(child);
			_state = AdapterState.DEFAULT_STATE;			
		}		
		
		public function set baseWidth(value:int):void 
		{
			_baseWidth = value;
			updateLayout()
		}
		
		public function set baseHeight(value:int):void 
		{
			_baseHeight = value;
			updateLayout()
		}
		
		
		public function setLayout(x:int, y:int, width:int, height:int):void 
		{
			this.x = x;
			this.y = y;
			_baseWidth = width;
			_baseHeight = height;
			updateLayout();
		}		
		
		private function updateLayout():void 
		{
			//trace("--------------------------------------------", _state.index);
			child.rotation = -_state.rotation;
			child.scaleX = _state.scaleX;
			
			var newX:int = _state.dxw * _baseWidth + _state.dxh * _baseHeight;
			var newY:int = _state.dyw * _baseWidth + _state.dyh * _baseHeight;
			var newWidth:int = _state.w2w * _baseWidth + _state.h2w * _baseHeight;
			var newHeight:int = _state.w2h * _baseWidth + _state.h2h * _baseHeight;
			
			if (child is ILayoutable)
			{
				(child as ILayoutable).setLayout(newX, newY, newWidth, newHeight);
			}
			else
			{
				child.x = newX;
				child.y = newY;
				
				LayoutUtil.setWidth(child, newWidth);
				LayoutUtil.setHeight(child, newHeight);
			}
			/*
			trace("x:", _state.dxw, "*", _baseWidth, "+", _state.dxh + "*" + _baseHeight, "=", child.x);  
			trace("y:", _state.dyw, "*", _baseWidth, "+", _state.dyh + "*" + _baseHeight, "=", child.y);  
			trace("x:", child.x, "y:", child.y, 
					"width:", _state.w2w * _baseWidth + _state.h2w * _baseHeight, 
					"height:", _state.w2h * _baseWidth + _state.h2h * _baseHeight);*/
		}
		
		public function get baseWidth():int 
		{
			return _baseWidth;
		}
		
		public function get baseHeight():int 
		{
			return _baseHeight;
		}
		
		public function rotate90():RotationAdapter 
		{
			_state = _state.onRot90;
			updateLayout();
			return this;
		}
		
		public function rotate180():RotationAdapter 
		{
			_state = _state.onRot90.onRot90;
			updateLayout();
			return this;
		}
		
		public function rotate270():RotationAdapter 
		{
			_state = _state.onRot90.onRot90.onRot90;
			updateLayout();
			return this;
		}
		
		public function flipHor():RotationAdapter 
		{
			_state = _state.onFlip.onRot90.onRot90;
			updateLayout();
			return this;
		}
		
		public function flipVert():RotationAdapter 
		{
			_state = _state.onFlip;
			updateLayout();
			return this;
		}		
	}
}

class AdapterState
{
	static public var DEFAULT_STATE:AdapterState;
	
	static private var _inited:Boolean;
	
	public var dxw:int;
	public var dxh:int;
	public var dyw:int;
	public var dyh:int;
	
	public var h2w:int;
	public var h2h:int;
	public var w2h:int;
	public var w2w:int;
	
	public var rotation:int;
	public var scaleX:int;
	public var onRot90:AdapterState;
	public var onFlip:AdapterState;
	public var index:int;
	
	public function AdapterState(dxw:int, dxh:int, dyw:int, dyh:int,
								h2w:int, h2h:int, w2h:int, w2w:int, 
								rotation:int, scaleX:int, index:int)
	{
			this.index = index;
			this.scaleX = scaleX;
			this.rotation = rotation;
			this.w2w = w2w;
			this.w2h = w2h;
			this.h2h = h2h;
			this.h2w = h2w;
			this.dyh = dyh;
			this.dyw = dyw;
			this.dxh = dxh;
			this.dxw = dxw;
	}
	
	public function setStates(onRot90:AdapterState, onFlip:AdapterState):void
	{
		this.onFlip = onFlip;
		this.onRot90 = onRot90;		
	}
	
	static public function init():void 
	{
		if (_inited)
			return;
		var state1:AdapterState = new AdapterState(0, 0, 0, 0,	0, 1, 0, 1, 	0, 1, 1);
		var state2:AdapterState = new AdapterState(0, 0, 0, 1,	1, 0, 1, 0, 	90, 1, 2);
		var state3:AdapterState = new AdapterState(1, 0, 0, 1,	0, 1, 0, 1, 	180, 1, 3);
		var state4:AdapterState = new AdapterState(1, 0, 0, 0,	1, 0, 1, 0, 	270, 1, 4);
		
		var state5:AdapterState = new AdapterState(1, 0, 0, 0,	0, 1, 0, 1, 	0, -1, 5);
		var state6:AdapterState = new AdapterState(0, 0, 0, 0,	1, 0, 1, 0, 	90, -1, 6);
		var state7:AdapterState = new AdapterState(0, 0, 0, 1,	0, 1, 0, 1, 	180, -1, 7);
		var state8:AdapterState = new AdapterState(1, 0, 0, 1,	1, 0, 1, 0, 	270, -1, 8);
		
		state1.setStates(state2, state7);
		state2.setStates(state3, state6);
		state3.setStates(state4, state5);
		state4.setStates(state1, state8);
		
		state5.setStates(state6, state3);
		state6.setStates(state7, state2);
		state7.setStates(state8, state1);
		state8.setStates(state5, state4);
		
		DEFAULT_STATE = state1;
	}
}