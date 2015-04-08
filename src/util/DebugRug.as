package util 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class DebugRug 
	{
		
		static public function getDebugID(object:*):String
		{
			var memoryHash:String;

			try
			{
				FakeClass(object);
			}
			catch (e:Error)
			{
				memoryHash = String(e).replace(/.*([@|\$].*?) to .*$/gi, '$1');
			}
			return memoryHash;
		}
		
		static public function getCurrentStack(tag:String = "", maxDepth:int = int.MAX_VALUE):String
		{
			try
			{
				FakeClass(new Object());
			}
			catch (e:Error)
			{
				var stack:String = e.getStackTrace();
				stack = stack.substr(stack.indexOf("\n") + 1);
				stack = stack.substr(stack.indexOf("\n") + 1);
				var parts:Array = stack.split("]\n");
				parts = parts.slice(0, maxDepth);
				for (var i:int = 0; i < parts.length; i++) 
				{
					if (parts[i].indexOf("::") != -1)
					{
						var arr:Array = parts[i].split("::");
						parts[i] = "\tat " + arr[arr.length - 1];
					}
				}
				stack = parts.join("]\n");
				return tag + ":   (" + getTimer().toString() + ")\n" + stack;
			}
			return "error: failed to create error";
		}
		
		public static function traceInteractiveObjectsUnderPoint(stage:Stage):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			function onMouseDown(e:MouseEvent):void
			{
				var objects:Array = stage.getObjectsUnderPoint(new Point(e.stageX, e.stageY));
				var interObjects:Vector.<InteractiveObject> = getAllInteractiveObjects(objects);
				trace("mouse sensative objects under", e.stageX, e.stageY);
				for (var i:int = 0; i < interObjects.length; i++) 
				{
					trace(interObjects[i], interObjects[i].name, "mouseEnabled:", InteractiveObject(interObjects[i]).mouseEnabled);
				}
			}
		}
		
		/**
	     * Finds interative objects in the display tree
	     * @param objectsUnderPoint leaves of the display tree that present interest. 
	     * 		Typically these are the result of the stage.getObjectsUnderPoint call.
	     * @return All interactive objects in the order at which they would intercept mouse events. The objects 
	     * are either the supplied leaves themselves or their ancestors. Does not include stage.
	     */
		static public function getAllInteractiveObjects(objectsUnderPoint:Array):Vector.<InteractiveObject>
		{
			var result:Vector.<InteractiveObject> = new Vector.<InteractiveObject>();
			for (var i:int = 0; i < objectsUnderPoint.length; i++) 
			{
				var obj:DisplayObject = objectsUnderPoint[i] as DisplayObject;
				var vec:Vector.<InteractiveObject> = new Vector.<InteractiveObject>();
				var hasInsertionPoint:Boolean = false;
				while (obj.parent)
				{
					if (obj is InteractiveObject)
					{
						if (result.indexOf(obj as InteractiveObject) == -1)
							vec.push(obj);
						else
						{
							result = vec.concat(result);
							hasInsertionPoint = true;
							break;
						}
					}
					obj = obj.parent;
				}
				if (!hasInsertionPoint)
					result = vec.concat(result);
			}
			return result;
		}

	}

}
final class FakeClass { }