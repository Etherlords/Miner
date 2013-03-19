package model 
{
	import flash.system.Security;
	import flash.system.System;
	import starling.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import starling.events.EventDispatcher;
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
	
		
		
		public static var texturesAtlas:TextureAtlas;
		
		public static var numbers:Array = [];
		
		private var toLoad:Array = ['desyrel.fnt', 'arts.xml']
		private var files:Object = { };
		private var decoders:Object = { 'fnt':new XMLDecoder(), 'xml':new XMLDecoder(), 'png':new PngDecoder(), 'atf':new ATFDecoder()};
		private var toDecode:Number;
		
		public function preload():void
		{
			var asset:String = 'arts';
			
			var version:Array = Capabilities.version.split(' ')[1].split(',');
	
			if (version[0] == 11 && version[1] >= 4 && Security.sandboxType != Security.APPLICATION)
			{
				asset += '.atf';
			}
			else
			{
				asset += '.png';
			}
			
			toLoad.push(asset);
			toDecode = toLoad.length;
			load();
		}
		
		private function load():void
		{
			if (toLoad.length == 0)
			{
				loadingComplete()
				return;
			}
				
				
			var file:String = toLoad.pop();
			var r:URLRequest = new URLRequest(file);
			
			var loader:URLLoader = new URLLoader(r);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, Delegate.create(onLoaded, file, loader));
		}
		
		private function loadingComplete():void 
		{
			
			for (var file:String in files)
			{
				
				var format:String = file.split('.')[1];
				var decoder:IDecoder = decoders[format];
				
				decoder.addEventListener(Event.COMPLETE, Delegate.create(onFileDecoded, decoder, file))
				decoder.decode(files[file]);
			}
		}
		
		private function onFileDecoded(decoder:IDecoder, file:String):void 
		{
			trace('onDecoded', arguments);
			files[file] = decoder.data;
			toDecode--;
			
			if (toDecode == 0)
				allComplete();
		}
		
		private function onLoaded(e:*, f:String, loader:URLLoader):void 
		{
			files[f] = loader.data;
			load();
		}
		
		private function allComplete():void 
		{
			if(files.hasOwnProperty('arts.atf'))
			{
				trace('create atf atlas');
				texturesAtlas = new TextureAtlas(Texture.fromAtfData(files['arts.atf']), files['arts.xml']);
			}
			else
			{
				trace('create bitmap atlas');
				texturesAtlas = new TextureAtlas(Texture.fromBitmapData(files['arts.png'], true, true), files['arts.xml'])
			}
			
			
			
			var texture:Texture = texturesAtlas.getTexture('desyrel');// getTexture("DesyrelTexture");
			
			var xml:XML = XML(files['desyrel.fnt']);
			var bitmapFont:BitmapFont = new BitmapFont(texture, xml)
			bitmapFont.smoothing = TextureSmoothing.TRILINEAR;
			TextField.registerBitmapFont(bitmapFont);
			
			
			for (var i:int = 0; i < 10; i++)
			{
				var key:Texture = bitmapFont.getChar(i.toString().charCodeAt(0)).texture;
				
				
				numbers.push(Texture.fromTexture(key));
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function TextureStore() 
		{
			
		}
		
		
		
	}

}