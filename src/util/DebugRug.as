package util 
{
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

	}

}
final class FakeClass { }