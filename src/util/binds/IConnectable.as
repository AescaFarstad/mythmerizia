package util.binds
{
	public interface IConnectable
	{
		function connect(to:Parameter, type:int):ParamConnection;
		function get connections():Vector.<ParamConnection>;
	}
}
