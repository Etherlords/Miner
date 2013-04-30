package view.components.progressBar 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Nikro
	 */
	public class ProgressBar extends Sprite
	{
		public var maxWidth:Number = 500;
		
		private var convasContainer:Bitmap;
		private var convas:BitmapData;
		private var _progressModel:Model;
		
		public function ProgressBar() 
		{
			initilize();
		}
		
		private function initilize():void 
		{
			_progressModel = new Model();
			convasContainer = new Bitmap();
			convas = convasContainer.bitmapData;
			
			
		}
		
		public function update():void
		{
			draw();
		}
		
		private function draw():void
		{
			graphics.clear();
			drawTiled(progressModel.bgPattern, maxWidth);
			drawTiled(progressModel.progressPattern, maxWidth * progressModel.progress);
		}
		
		private function drawTiled(source:BitmapData, w:Number):void
		{
			graphics.beginBitmapFill(source);
			graphics.drawRect(0, 0, w, source.height);			
		}
		
		public function get progressModel():Model 
		{
			return _progressModel;
		}
		
	}

}