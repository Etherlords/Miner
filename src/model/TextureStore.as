package model 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author 
	 */
	public class TextureStore 
	{
		
		[Embed(source="../../lib/Ubuntu-R.ttf", embedAsCFF="false", fontFamily="Ubuntu")]        
        private static const UbuntuRegular:Class;
		
		[Embed(source = "../../lib/gnomemines.png")]
		private var mineSource:Class;
		private var mineImage:BitmapData = new mineSource().bitmapData;
		
		[Embed(source = "../../lib/button_normal.png")]
		private var buttonSources:Class;
		private var buttonImage:BitmapData = new buttonSources().bitmapData;
		
		[Embed(source = "../../lib/button_big.png")]
		private var button2Sources:Class;
		private var button2Image:BitmapData = new button2Sources().bitmapData;
		
		[Embed(source = "../../lib/button_square.png")]
		private var button3Sources:Class;
		private var button3Image:BitmapData = new button3Sources().bitmapData;
		
		public static var mineTexture:Texture;
		
		public static var textures:Object = { };
		
		private var statusColor:Array = [0x666666, 0xCCCCCC, 0xFFFFFF];
		
		private var fillColor:uint = statusColor[0];
		
		public function TextureStore() 
		{
			textures['mine'] = Texture.fromBitmapData(mineImage, true, true, 3);
			textures['button0Texture'] = Texture.fromBitmapData(buttonImage, true, true);
			textures['button1Texture'] = Texture.fromBitmapData(button2Image, true, true);
			textures['button2Texture'] = Texture.fromBitmapData(button3Image, true, true);
			
			
			
			createFlagTexture();
			createFieldTextures();
		}
		
		private function drawFlag(shape:Shape):void
		{
			var graphics:Graphics = shape.graphics;
			var flagSpace:Number = CellConstants.MINE_FIELD_GABARITE / 3;
			graphics.lineStyle(4, 0)
			graphics.beginFill(0xFF0000);
			
			
			var currentX:Number = flagSpace;
			var currentY:Number = CellConstants.MINE_FIELD_GABARITE - flagSpace / 2;
			
			graphics.moveTo(currentX, currentY);
			
			currentX = flagSpace;
			currentY = flagSpace / 2;
			graphics.lineTo(currentX, currentY);
			
			currentX = flagSpace *2;
			currentY = flagSpace 
			graphics.lineTo(currentX, currentY);
			
			currentX = flagSpace;
			currentY = flagSpace * 1.5;
			graphics.lineTo(currentX, currentY);
		}
		
		private function drawField(shape:Shape, alpha:Number = 1):void
		{
			var graphics:Graphics = shape.graphics;
			graphics.clear();
			graphics.beginFill(fillColor, alpha);
			
			graphics.lineStyle(2, 0, alpha, true, 'noScale')
			graphics.drawRect(1, 1, CellConstants.MINE_FIELD_GABARITE-2, CellConstants.MINE_FIELD_GABARITE-2);
		}
		
		private function getShapeBounds(shape:Shape):Rectangle
		{
			var bounds:Rectangle = shape.getBounds(shape)
			bounds.x = Math.abs(bounds.x);
			bounds.y = Math.abs(bounds.y);
			
			bounds.width = bounds.width + bounds.x;
			if (bounds.width < 1)
				bounds.width = 1;
			
			if (bounds.height < 1)
				bounds.height = 1;
				
			bounds.height = bounds.height + bounds.y;
			
			return bounds;
		}
		
		private function drawTexture(shape:Shape):Texture
		{
			var bounds:Rectangle = getShapeBounds(shape);
			
			var bitmapSource:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x0);
			var m:Matrix = new Matrix();
			m.tx = bounds.x;
			m.ty = bounds.y;
			
			bitmapSource.draw(shape, m);
			
			return Texture.fromBitmapData(bitmapSource, true, true);
		}
		
		private function createFlagTexture():void 
		{
			var flagShape:Shape = new Shape();
			
			drawField(flagShape, 0);
			drawFlag(flagShape);
			
			var flagTexture:Texture = drawTexture(flagShape);
			
			textures['flagTexture'] = flagTexture;
		}
		
		private function createFieldTextures():void 
		{
			var field:Shape = new Shape();
			
			for (var i:int = 0; i < statusColor.length; i++)
			{
				fillColor = statusColor[i]
				drawField(field);
				
				textures['fieldTexture' + i] = drawTexture(field);
				trace(textures['fieldTexture' + i].width, textures['fieldTexture' + i].height);
			}
		}
		
	}

}