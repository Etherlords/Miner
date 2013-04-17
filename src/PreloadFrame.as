package
{
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
		
		public function PreloadFrame()
		{
			initilize();
		}
		
		private function initilize():void
		{
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void
		{
			graphics.clear();
			
			if (framesLoaded == totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME, onFrame);
				graphics.clear();
				nextFrame();
				
				complete();
				
				
				return;
				
			}
			
			var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, stage.stageWidth * percent, stage.stageHeight);
			graphics.endFill();
			
			trace(root.loaderInfo.bytesLoaded, root.loaderInfo.bytesTotal);
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