package utils.decoders 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class ATFDecoder extends EventDispatcher implements IDecoder
	{
		private var _data:*;
		
		public function ATFDecoder() 
		{
			
		}
		
		/* INTERFACE utils.decoders.IDecoder */
		
		public function decode(data:ByteArray):void 
		{
			_data = data
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		public function get data():* 
		{
			return _data;
		}
		
	}

}