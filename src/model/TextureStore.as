package model 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author 
	 */
	public class TextureStore 
	{
		
		[Embed(source="../../FDBuild/asset/desyrel.fnt", mimeType="application/octet-stream")]
        public static const DesyrelXml:Class;
		
		//[Embed(source="../../lib/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]        
        //private static const UbuntuRegular:Class;
		
		[Embed(source = "../../FDBuild/asset/arts.png")]
		private var assetSource:Class;
		private var assetBitmap:BitmapData = new assetSource().bitmapData;
		
		[Embed(source = "../../FDBuild/asset/arts.xml", mimeType = "application/octet-stream")]
		private static var assetConfigSoruce:Class;
		private static var assetConfigStream:ByteArray = new assetConfigSoruce();
		private var assetConfig:XML = new XML(assetConfigStream.readUTFBytes(assetConfigStream.length));
		
		public static var texturesAtlas:TextureAtlas;
		
		public function TextureStore() 
		{
			
			texturesAtlas = new TextureAtlas(Texture.fromBitmapData(assetBitmap, true, true), assetConfig)
			
			var texture:Texture = texturesAtlas.getTexture('desyrel');// getTexture("DesyrelTexture");
			var xml:XML = XML(new DesyrelXml);
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
		}
		
		
		
	}

}