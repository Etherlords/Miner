package  
{
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Nikro
	 */
	public class MinimalAsset 
	{
		
		[Embed(source = "/../asset/preloader_bg.png")]
		private static var preloaderSource_bg:Class;
		private static var _preloaderBgTexture:Texture;
		
		[Embed(source = "/../asset/preloader.png")]
		private static var preloaderSource:Class;
		private static  var _preloaderTexture:Texture;
		
		[Embed(source = "/../asset/bg_load.jpg")]
		public static var loadBgSource:Class;
		private static  var _loadBgTexture:Texture;
		
		static public function get loadBgTexture():Texture 
		{
			if (!_loadBgTexture)
				_loadBgTexture = Texture.fromBitmap(new loadBgSource);
				
			return _loadBgTexture;
		}
		
		static public function get preloaderTexture():Texture 
		{
			if (!_preloaderTexture)
				_preloaderTexture = Texture.fromBitmap(new preloaderSource);
			return _preloaderTexture;
		}
		
		static public function get preloaderBgTexture():Texture 
		{
			if (!_preloaderBgTexture)
				_preloaderBgTexture = Texture.fromBitmap(new preloaderSource_bg);
			
			return _preloaderBgTexture;
		}
	}

}