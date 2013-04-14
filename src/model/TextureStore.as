package model 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.Security;
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
	public class TextureStore extends TestObj implements ITest, IEventDispatcher
	{
		private var texturesAtlas:TextureAtlas;
		
		public static var numbers:Array = [];
		
		private var toLoad:Array = ['a_LCDNova.fnt', 'asset.xml', 'bg.png', 'bg2.png'];
		private var files:Object = { };
		private var decoders:Object = { 'fnt':XMLDecoder, 'xml':XMLDecoder, 'jpg':PngDecoder, 'png':PngDecoder, 'atf':ATFDecoder};
		private var toDecode:Number;
		private var assetName:String;
		private var assetFormat:String;
		private var currentFiled:String;
		private var progress:ProgressEvent;
		
		public function getTexture(name:String):Texture
		{
			var texture:Texture = texturesAtlas.getTexture(name)
			if (!texture)
			{
				if (files[name])
				{
					texture = Texture.fromBitmapData(files[name]);
				}
			}
			
			return texture;
		}
		
		public function preload():void
		{
			assetName = 'asset';
			assetFormat = ''
			
			var version:Array = Capabilities.version.split(' ')[1].split(',');
	
			if (false)//version[0] == 11 && version[1] >= 4 && Security.sandboxType != Security.APPLICATION)
			{
				assetFormat = '.atf';
			}
			else
			{
				assetFormat = '.png';
			}
			
			toLoad.push(assetName+assetFormat);
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
				
				
			currentFiled = toLoad.pop();
			var r:URLRequest = new URLRequest(currentFiled);
			
			var loader:URLLoader = new URLLoader(r);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, Delegate.create(onLoaded, currentFiled, loader));
			loader.addEventListener(ProgressEvent.PROGRESS, Delegate.create(onProgress, currentFiled, loader));
		}
		
		private function onProgress(e:ProgressEvent, f:String, loader:URLLoader):void
		{
			progress = e;
		}
		
		private var progressIndicator:String = '|||||||||||||||||||';
		public function getLoadingInfo():String
		{
			var s:String = '';
			s = 'To load list		: ' + toLoad.join(', ') + ' \n';
			s += 'Currently load	: ' + currentFiled + ' \n';
			var percent:Number = progress? progress.bytesLoaded / progress.bytesTotal : 0;
			s += 'Progress		: ' + progressIndicator.substr(0, Math.floor(progressIndicator.length * percent)) + ' \n';
			s += 'Bytes			: ' + (progress? progress.bytesLoaded:0) + '/' + (progress? progress.bytesTotal:0) + '';
		 	
			return s;
		}
		
		private function loadingComplete():void 
		{
			
			for (var file:String in files)
			{
				
				var format:String = file.split('.')[1];
				var decoder:IDecoder = new decoders[format] as IDecoder;
				
				decoder.addEventListener(Event.COMPLETE, Delegate.create(onFileDecoded, decoder, file))
				decoder.decode(files[file]);
			}
		}
		
		private function onFileDecoded(decoder:IDecoder, file:String):void 
		{
			files[file] = decoder.data;
			toDecode--;
			decoder.destroy();
			
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
			var assetSource:String = assetName + assetFormat;
			var assetSettings:String = assetName + '.xml';
			if(files.hasOwnProperty(assetFormat == '.atf'))
			{
				trace('create atf atlas');
				texturesAtlas = new TextureAtlas(Texture.fromAtfData(files[assetSource]), files[assetSettings]);
			}
			else
			{
				trace('create bitmap atlas');
				texturesAtlas = new TextureAtlas(Texture.fromBitmapData(files[assetSource]), files[assetSettings])
				var theme:Theme = new Theme(texturesAtlas);
			}
			
			
			
			var texture:Texture = texturesAtlas.getTexture('a_LCDNova_0');// getTexture("DesyrelTexture");
			
			var xml:XML = XML(files['a_LCDNova.fnt']);
			var bitmapFont:BitmapFont = new BitmapFont(texture, xml)
			bitmapFont.smoothing = TextureSmoothing.TRILINEAR;
			TextField.registerBitmapFont(bitmapFont);
			
			
			for (var i:int = 0; i < 10; i++)
			{
				var key:Texture = bitmapFont.getChar(i.toString().charCodeAt(0)).texture;
				
				
				numbers.push(Texture.fromTexture(key));
			}
			
			trace('preload complete');
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		public function TextureStore() 
		{
			super();
		}
	}

}