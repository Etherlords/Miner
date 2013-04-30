package
{
	import asset.MinimalAsset;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class PreloadFrame extends MovieClip
	{
		private var bg:Bitmap;
		
		public function PreloadFrame()
		{
			initilize();
		}
		
		private function initilize():void
		{
			bg = new Bitmap(MinimalAsset.bg_load);
			addChild(bg);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void
		{
			graphics.clear();
			
			if (framesLoaded == totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME, onFrame);
				
				removeChild(bg);
				
				nextFrame();
				
				complete();
				
				
				return;
				
			}
			
			var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
			
		}
		
		private function complete():void
		{
			
			var mainClass:Class = Class(getDefinitionByName('StarlingInit'));
			if (mainClass)
			{
				var app:Object = new mainClass();
				addChild(app as DisplayObject);
			}
		}
	
	}

}