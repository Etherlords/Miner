package  asset
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Nikro
	 */
	public class MinimalAsset 
	{
		
		[Embed(source = "/../asset/preloader_bg.png")]
		private static var preloaderSource_bg:Class;
		public static var preloader_bg:BitmapData = new preloaderSource_bg().bitmapData; 
		
		[Embed(source = "/../asset/preloader.png")]
		private static var preloaderSource:Class;
		public static var preloader:BitmapData = new preloaderSource().bitmapData;
		
		[Embed(source = "/../asset/bg_load.jpg")]
		public static var loadBgSource:Class;
		public static var bg_load:BitmapData = new loadBgSource().bitmapData;
		
		[Embed(source = "/../asset/fonts/a_LCDNova.ttf", fontName = "a_LCDNova", mimeType = "application/x-font", embedAsCFF = "false")]
		protected static const LCD_NOVA_FONT:Class;

	
	}

}