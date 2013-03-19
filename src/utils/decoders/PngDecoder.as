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
	public class PngDecoder extends EventDispatcher implements IDecoder
	{
		private var loader:Loader;
		private var _data:*;
		
		public function PngDecoder() 
		{
			
		}
		
		/* INTERFACE utils.decoders.IDecoder */
		
		public function decode(data:ByteArray):void 
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.loadBytes(data);
		}
		
		private function onComplete(e:*):void 
		{
			var bitmap:BitmapData = (loader.content as Bitmap).bitmapData;
			_data = bitmap;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get data():* 
		{
			return _data;
		}
		
	}

}