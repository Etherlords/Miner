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
	public class XMLDecoder extends EventDispatcher implements IDecoder
	{
		private var _data:*;
		
		public function XMLDecoder() 
		{
			
		}
		
		/* INTERFACE utils.decoders.IDecoder */
		
		public function decode(data:ByteArray):void 
		{
			data.position = 0;
			_data = new XML(data.readUTFBytes(data.length));
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		public function get data():* 
		{
			return _data;
		}
		
	}

}