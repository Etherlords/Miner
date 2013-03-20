package utils.decoders 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IDecoder 
	{
		function addEventListener(type:String, listener:Function):void
		function decode(data:ByteArray):void
		function get data():*
		function destroy():void
	}
	
}