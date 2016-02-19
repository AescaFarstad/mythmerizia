package util.binds 
{
	import org.osflash.signals.Signal;

	public interface IBindable 
	{
		function get onChange():Signal;
		function get value():Number;
		function get name():String;
	}
	
}