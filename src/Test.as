package  
{
	import asset.MinimalAsset;
	import flash.display.Sprite;
	import flash.events.Event;
	import view.components.progressBar.ProgressBar;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class Test extends Sprite 
	{
		private var progress:ProgressBar;
		
		public function Test() 
		{
			super();
			
			progress = new ProgressBar();
			progress.progressModel.bgPattern = MinimalAsset.preloader_bg;
			progress.progressModel.progressPattern = MinimalAsset.preloader;;
			
			addEventListener(Event.ENTER_FRAME, onFram);
			
			addChild(progress);
		}
		
		private function onFram(e:Event):void 
		{
			progress.progressModel.progress += 0.005;
			
			if (progress.progressModel.progress > 1)
				progress.progressModel.progress = 0;
		}
		
	}

}