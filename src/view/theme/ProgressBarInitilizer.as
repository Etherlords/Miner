package view.theme 
{
	import feathers.controls.ProgressBar;
	import feathers.core.DisplayListWatcher;
	import feathers.display.TiledImage;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Nikro
	 */
	public class ProgressBarInitilizer extends DisplayListWatcher
	{
		private var progressBackground:Texture;
		private var progress:Texture;
		
		public function ProgressBarInitilizer(container:DisplayObjectContainer = null) 
		{
			
			if(!container)
			{
				container = Starling.current.stage;
			}
			
			
			super(container)
			//progressBackground = MinimalAsset.preloaderBgTexture;
			//progress = MinimalAsset.preloaderTexture;
			
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
		}
		
		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:TiledImage = new TiledImage(this.progressBackground, 1);
			backgroundSkin.width = 240 * 1;
			backgroundSkin.height = 29 * 1;
			progress.backgroundSkin = backgroundSkin;
			
			const fillSkin:TiledImage = new TiledImage(this.progress, 1);
			fillSkin.width = 6 * 1;
			fillSkin.height = 29 * 1;
			progress.fillSkin = fillSkin;
		}
		
	}

}