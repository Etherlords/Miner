package
{
	import asset.MinimalAsset;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import view.components.progressBar.ProgressBar;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class PreloadFrame extends MovieClip
	{
		private var inited:Boolean = false;
		private var bg:Bitmap;
		private var progress:ProgressBar;
		
		public function PreloadFrame()
		{
			initilize();
		}
		
		private function initilize():void
		{
			progress = new ProgressBar();
			progress.maxWidth = stage.stageWidth - 100;
			
			progress.progressModel.bgPattern = MinimalAsset.preloader_bg;
			progress.progressModel.progressPattern = MinimalAsset.preloader;
			
			progress.x = (stage.stageWidth - progress.maxWidth) / 2;
			
			progress.y = stage.stageHeight - stage.stageHeight / 4;
			
			bg = new Bitmap(MinimalAsset.bg_load);
			bg.x = (stage.stageWidth - bg.width) / 2;
			bg.y = (stage.stageHeight - bg.height) / 2;
			
			
			addChild(bg);
			addChild(progress);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void
		{
			var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
			progress.progressModel.progress = percent;
			progress.update();
			
			if (framesLoaded == totalFrames)
			{
				if(!inited)
					complete();
				
				progress.alpha -= 0.025;
				bg.alpha = progress.alpha;
				
				if (progress.alpha <= 0)
				{
					removeEventListener(Event.ENTER_FRAME, onFrame);
					removeChild(bg);
					removeChild(progress);
				}
				
				
				return;
			}
			
			
		}
		
		private function complete():void
		{
			inited = true;
			var mainClass:Class = Class(getDefinitionByName('StarlingInit'));
			if (mainClass)
			{
				var app:Object = new mainClass();
				addChild(app as DisplayObject);
			}
		}
	
	}

}