package  tools.pool
{
	
	public interface IPoolable 
	{
		function get destroyed():Boolean;
		
		function renew(params:Object = null):void;
		function destroy():void;
	}
	
}