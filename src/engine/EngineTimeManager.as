package engine
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import util.EnterFramer;
	
	public class EngineTimeManager 
	{
		private static const FRAME_TIME:int = 18;
		public static const MAX_TIME_DELTA:int = 80;		
		
		private static const DEFAULT_ULTRA_MODE_MULTIPLIER:int = 3;
		
		private var _timeScale:Number = 1;
		private var _previousTimeScale:Number = 1;
		private var _logic:Object; //TODO make it an interface		
		private var _lastUpdateStamp:int;
		private var _isPaused:Boolean;
		private var _isUltraModeEnabled:Boolean;
		private var _ultraModeMultiplier:int;
		private var _fixedTimeDelta:int = -1;
		
		private var _num_2Pressed:Boolean;
		private var _num_5Pressed:Boolean;
		private var _num_8Pressed:Boolean;
		private var _spacePressed:Boolean;
		private var _multiplyPressed:Boolean;
		private var _isListeningToKeys:Boolean;
		private var _isActive:Boolean;
		
		public function EngineTimeManager() 
		{
		}
		
		public function load(logic:Object):void
		{
			_logic = logic;
			_lastUpdateStamp = getTimer();
			_isActive = true;
			addListeners();
			
			_isPaused = false;
			_timeScale = 1;
			_isUltraModeEnabled = false;
			_fixedTimeDelta = 15;
			_ultraModeMultiplier = DEFAULT_ULTRA_MODE_MULTIPLIER;
			EnterFramer.addEnterFrameUpdate(onFrame);
		}
		
		public function clear():void
		{
			_isActive = false;
			removeListeners()
		}
		
		private function addListeners():void
		{
			if (!_isListeningToKeys)
			{
				_logic.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				_logic.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				_isListeningToKeys = true;				
			}
		}
		
		private function removeListeners():void
		{
			_logic.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_logic.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_isListeningToKeys = false;
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			//change time scale
			if (e.keyCode ==  Keyboard.NUMPAD_0)
			{				
				_timeScale = 0;
				_fixedTimeDelta = -1;
			}
			if (e.keyCode ==  Keyboard.NUMPAD_1)
			{				
				_timeScale = 0.3;	
				_fixedTimeDelta = -1;
			}
			if (e.keyCode ==  Keyboard.NUMPAD_4)
			{				
				_timeScale = 1;
				_fixedTimeDelta = -1;
			}
			if (e.keyCode ==  Keyboard.NUMPAD_7)
			{				
				_timeScale = 2;
				_fixedTimeDelta = -1;
			}
			
			
			//change timescale while pressed. revert back when released
			if (e.keyCode ==  Keyboard.NUMPAD_2 && !_num_2Pressed)
			{
				_num_2Pressed = true;
				_previousTimeScale = _timeScale;
				_timeScale = 0.3;	
			}
			if (e.keyCode ==  Keyboard.NUMPAD_5 && !_num_5Pressed)
			{
				_num_5Pressed = true;
				_previousTimeScale = _timeScale;
				_timeScale = 1;	
			}	
			if (e.keyCode ==  Keyboard.NUMPAD_8 && !_num_8Pressed)
			{
				_num_8Pressed = true;
				_previousTimeScale = _timeScale;
				_timeScale = 2;
			}
			if (e.keyCode ==  Keyboard.NUMPAD_MULTIPLY && !_multiplyPressed)
			{
				_multiplyPressed = true;
				_isUltraModeEnabled = true;
			}
			
			//Paused
			if (e.keyCode ==  Keyboard.SPACE)
			{
				_isPaused = !_isPaused;				
			}
			
			//Pause and do manual steps
			if (e.keyCode ==  Keyboard.NUMPAD_3)
			{			
				_isPaused = true;	
				_logic.update(FRAME_TIME * 0.3);
			}
			if (e.keyCode ==  Keyboard.NUMPAD_6)
			{			
				_isPaused = true;	
				_logic.update(FRAME_TIME * 1);
			}
			if (e.keyCode ==  Keyboard.NUMPAD_9)
			{				
				_isPaused = true;
				_logic.update(FRAME_TIME * 2);
			}
		}
			
		private	function onKeyUp(e:KeyboardEvent):void
		{	
			//change timescale while pressed. revert back when released
			if (e.keyCode ==  Keyboard.NUMPAD_2)
			{
				_num_2Pressed = false;
				_timeScale = _previousTimeScale;
			}
			if (e.keyCode ==  Keyboard.NUMPAD_5)
			{
				_num_5Pressed = false;
				_timeScale = _previousTimeScale;
			}	
			if (e.keyCode ==  Keyboard.NUMPAD_8)
			{
				_num_8Pressed = false;
				_timeScale = _previousTimeScale;
			}
			if (e.keyCode ==  Keyboard.NUMPAD_MULTIPLY)
			{
				_multiplyPressed = false;
				_isUltraModeEnabled = false;
			}
		}
		
		public function onFrame(e:Event = null):void
		{
			var stamp:int = getTimer();
			if (!_isPaused || _num_2Pressed || _num_5Pressed || _num_8Pressed)
			{				
				_logic.update(Math.min((stamp - _lastUpdateStamp) * _timeScale, MAX_TIME_DELTA));
				if (_isUltraModeEnabled)
				{
					for (var i:int = 0; i < _ultraModeMultiplier; i++) 
					{
						if (_fixedTimeDelta > 0)
							_logic.update(_fixedTimeDelta);
						else
							_logic.update(Math.min((stamp - _lastUpdateStamp) * _timeScale, MAX_TIME_DELTA));
					}
				}
			}
			//trace("TT: " + (getTimer() - stamp));
			_lastUpdateStamp = stamp;
		}		
	}
}