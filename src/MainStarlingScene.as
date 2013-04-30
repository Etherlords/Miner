package  
{
	import feathers.controls.ProgressBar;
	import flash.text.TextField;
	import model.TextureStore;
	import scene.GameSceneBuilder;
	import scene.SceneControllerFactoryImpl;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	
	public class MainStarlingScene extends DisplayObjectContainer 
	{
		private var progress:TextField;
		private var progressBar:ProgressBar;
		private var back:Image;
		
		[Inject]
		public var texturesStore:TextureStore
		
		public function MainStarlingScene()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			
			inject(this);
			
			if (texturesStore.isInited)
				hereGo()
			else
				texturesStore.addEventListener(Event.COMPLETE, hereGo);
		}
		
		private function hereGo(e:* = null):void 
		{
			
			
			texturesStore.removeEventListener(Event.COMPLETE, hereGo);
			
			removeChild(progressBar);
			removeChild(back);
			
			new GameSceneBuilder(new SceneControllerFactoryImpl, this).buildSceneSequence();

		}
		
	}

}