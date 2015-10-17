package util.layout
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Provides ability to redefine the local anchor point of a container
	 * All positioning, rotating and scaling will then be done around this
	 * anchor point
	 */
	public class AnchoredSprite extends Sprite
	{
		//{	Properties
		
		/**
		 * The x position of the shape
		 */
		public override function get x():Number
		{
			return _x;
		}
		
		public override function set x(value:Number):void
		{
			setTransform(value, y, scaleX, scaleY, rotation);
		}
		
		private var _x:Number = 0;
		
		/**
		 * The y position of the shape
		 */
		public override function get y():Number
		{
			return _y;
		}
		
		public override function set y(value:Number):void
		{
			setTransform(x, value, scaleX, scaleY, rotation);
		}
		
		private var _y:Number = 0;
		
		/**
		 * The current scale in the x direction
		 */
		public override function get scaleX():Number
		{
			return _scaleX;
		}
		
		public override function set scaleX(value:Number):void
		{
			setTransform(x, y, value, scaleY, rotation);
		}
		
		private var _scaleX:Number = 1;
		
		/**
		 * The current scale in the y direction
		 */
		public override function get scaleY():Number
		{
			return _scaleY;
		}
		
		public override function set scaleY(value:Number):void
		{
			setTransform(x, y, scaleX, value, rotation);
		}
		
		private var _scaleY:Number = 1;
		
		/**
		 * The current rotation
		 */
		public override function get rotation():Number
		{
			return _rotation;
		}
		
		public override function set rotation(value:Number):void
		{
			setTransform(x, y, scaleX, scaleY, value);
		}
		
		private var _rotation:Number = 0;
		
		/**
		 * The point to perform transformations around (relative to local origin)
		 */
		public function get anchorPoint():Point
		{
			return _anchorPoint;
		}
		
		public function set anchorPoint(value:Point):void
		{
			_anchorPoint = value;
			_needsTransformUpdate = true;
		}
		
		private var _anchorPoint:Point = new Point();
		
		/**
		 * Returns the mouse x coordinate of this object
		 */
		override public function get mouseX():Number
		{
			return super.mouseX - anchorPoint.x;
		}
		
		/**
		 * Returns the mouse y coordinate of this object
		 */
		override public function get mouseY():Number
		{
			return super.mouseY - anchorPoint.y;
		}
		
		//}
		
		//{	Fields
		
		protected var _needsTransformUpdate:Boolean = false;
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function AnchoredSprite()
		{
			try
			{
				init();
			} catch (er:Error)
			{
				throw new Error("Error initialising");
			}
			
			// add listeners for addition to and removal from stage
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
			// if stage is ready call added to stage handler
			if (stage)
			{
				onAddedToStage(null);
			}
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Sets the transform point of the shape
		 */
		public function setAnchorPoint(coord:Object):void
		{
			try
			{
				_anchorPoint.x = coord["x"];
				_anchorPoint.y = coord["y"];
				_needsTransformUpdate = true;
			} catch (er:Error)
			{
				throw new Error("Error accessing coordinate information from " + getQualifiedClassName(coord));
			}
		}
		
		/**
		 * Sets the current transform of the shape (relative to the origin)
		 */
		public function setTransform(x:Number, y:Number, sX:Number, sY:Number, rotation:Number):void
		{
			// store properties
			this._x = x;
			this._y = y;
			this._scaleX = sX;
			this._scaleY = sY;
			this._rotation = rotation;
			
			// set transform flag so the matrix gets updated before the next draw
			_needsTransformUpdate = true;
			
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class before addition to stage
		 */
		protected function init():void
		{
			// HANDLE FOR CONSTRUCTOR
		}
		
		/**
		 * Calculates and updates the current transformation matrix
		 */
		public function updateTransform():void
		{
			// create new matrix
			var tm:Matrix = new Matrix();
			
			// translate to the new anchor point
			tm.translate(-anchorPoint.x, -anchorPoint.y);
			
			// now apply scale, rotation and then translate to new x and y
			tm.scale(scaleX, scaleY);
			tm.rotate(rotation * 0.017453292519943295);
			tm.translate(x, y);
			
			// update matrix
			transform.matrix = tm;
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles addition to the stage
		 */
		protected function onAddedToStage(event:Event):void
		{
			// listen for enter frame to redraw the shape
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			enterFrameHandler(null);
		}
		
		/**
		 * Handles removal from the stage
		 */
		protected function onRemovedFromStage(event:Event):void
		{
			// remove listeners for enter frame from stage
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * Handles enter frame events
		 */
		private function enterFrameHandler(event:Event):void
		{
			// check if the transform needs to be updated and update it
			if (_needsTransformUpdate)
			{
				updateTransform();
				_needsTransformUpdate = false;
			}
		}
		
		//}
	}
}
