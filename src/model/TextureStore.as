package model 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.ByteArray;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author 
	 */
	public class TextureStore 
	{
		
		[Embed(source="../../FDBuild/asset/desyrel.fnt", mimeType="application/octet-stream")]
        public static const DesyrelXml:Class;
		
		[Embed(source = "../../FDBuild/asset/arts.png")]
		private var assetBitmapSource:Class;
		private var assetBitmap:BitmapData = new assetBitmapSource().bitmapData;
		
		[Embed(source = "../../FDBuild/asset/starParticle.png")]
		private var starsSource:Class;
		private var starsBitmap:BitmapData = new starsSource().bitmapData;
		
		[Embed(source="../../FDBuild/asset/arts.xml", mimeType="application/octet-stream")]
		private static var assetConfigSoruce:Class;
		private static var assetConfigStream:ByteArray = new assetConfigSoruce();
		private var assetConfig:XML = new XML(assetConfigStream.readUTFBytes(assetConfigStream.length));
		
		[Embed(source="../../FDBuild/asset/arts.atf", mimeType="application/octet-stream")]
		private static var assetSource:Class;
		private static var assetStream:ByteArray = (new assetSource() as ByteArray)
		
		public static var starParticle:Texture;
		
		public static var texturesAtlas:TextureAtlas;
		
		public static var numbers:Array = [];
		
		public function TextureStore() 
		{
			starParticle = Texture.fromBitmapData(starsBitmap, true, true);
			
			var version:Array = Capabilities.version.split(' ')[1].split(',');
			
			if (version[0] == 11 && version[1] >= 4)
			{
				trace('create atf atlas');
				texturesAtlas = new TextureAtlas(Texture.fromAtfData(assetStream), assetConfig);
			}
			else
			{
				trace('create bitmap atlas');
				texturesAtlas = new TextureAtlas(Texture.fromBitmapData(assetBitmap, true, true), assetConfig)
			}
			
			
			
			var texture:Texture = texturesAtlas.getTexture('desyrel');// getTexture("DesyrelTexture");
			
			var xml:XML = XML(new DesyrelXml);
			var bitmapFont:BitmapFont = new BitmapFont(texture, xml)
			bitmapFont.smoothing = TextureSmoothing.TRILINEAR;
			TextField.registerBitmapFont(bitmapFont);
			
			for (var i:int = 0; i < 10; i++)
			{
				var key:Texture = bitmapFont.getChar(i.toString().charCodeAt(0)).texture;
				
				
				numbers.push(Texture.fromTexture(key));
			}
		}
		
		
		
	}

}