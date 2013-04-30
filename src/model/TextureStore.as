package model 
{
	import asset.GameAsset;
	import core.collections.SimpleMap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.as3commons.zip.Zip;
	import org.as3commons.zip.ZipFile;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import utils.decoders.ATFDecoder;
	import utils.decoders.IDecoder;
	import utils.decoders.PngDecoder;
	import utils.decoders.XMLDecoder;
	
	/**
	 * ...
	 * @author 
	 */
	public class TextureStore extends EventDispatcher
	{
		public var isInited:Boolean = false;
		
		private var texturesAtlas:TextureAtlas;
		private var zip:Zip;
		
		private var unpackedFiles:SimpleMap = new SimpleMap();
		
		public static var numbers:Array = [];
		
		private var decoders:Object = { 'fnt':XMLDecoder, 'xml':XMLDecoder, 'jpg':PngDecoder, 'png':PngDecoder, 'atf':ATFDecoder};
		
		public static const LOAD_BG:String = 'bg_load.jpg';
		public static const START_BG:String = 'bg_start.jpg';
		public static const MENU_BG:String = 'bg_menu.jpg';
		public static const GAME_BG:String = 'bg_game.jpg';
		public static const GAME_BG_C:String = 'bg_game_c.jpg';
		
		public function TextureStore() 
		{
			super();
			
			initilize();
		}
		
		private function initilize():void 
		{
			zip = GameAsset.getZip();
			prepareAsset();
		}
		
		private function prepareAsset():void 
		{
			var fileFirmat:String;
			var file:ZipFile;
			for (var i:int = 0; i < zip.getFileCount(); ++i)
			{
				file = zip.getFileAt(i);
				
				fileFirmat = file.filename.split('.')[1];
				
				var decoder:IDecoder = new decoders[fileFirmat];
				decoder.addEventListener(Event.COMPLETE, Delegate.create(onDecoded, file.filename, decoder));
				decoder.decode(file.content);
				
			}
		}
		
		private function onDecoded(filename:String, decoder:IDecoder):void 
		{
			unpackedFiles.addItem(filename, decoder.data);
			
			if (unpackedFiles.length == zip.getFileCount())
				allComplete();
		}
		
		public function getTexture(name:String):Texture
		{
			var texture:Texture = texturesAtlas.getTexture(name)
			if (!texture)
			{
				if (zip.getFileByName(name))
				{
					
					
					texture = Texture.fromBitmapData(unpackedFiles.getItem(name));
				}
			}
			
			return texture;
		}
		
		private function allComplete():void 
		{
			texturesAtlas = new TextureAtlas(Texture.fromBitmapData(unpackedFiles.getItem('asset.png')), unpackedFiles.getItem('asset.xml'))
			var theme:Theme = new Theme(texturesAtlas);

			var texture:Texture = texturesAtlas.getTexture('a_LCDNova_0');
			
			var xml:XML = XML(unpackedFiles.getItem('a_LCDNova.fnt'));
			var bitmapFont:BitmapFont = new BitmapFont(texture, xml)
			bitmapFont.smoothing = TextureSmoothing.TRILINEAR;
			TextField.registerBitmapFont(bitmapFont);
			
			
			for (var i:int = 0; i < 10; i++)
			{
				var key:Texture = bitmapFont.getChar(i.toString().charCodeAt(0)).texture;
				
				
				numbers.push(Texture.fromTexture(key));
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
			
			isInited = true;
		}
	}

}