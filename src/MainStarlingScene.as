package  
{
	import feathers.controls.ProgressBar;
	import flash.text.TextField;
	import model.TextureStore;
	import particles.boomParticle.BoomParticle;
	import scene.GameSceneBuilder;
	import scene.SceneControllerFactoryImpl;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import utils.GlobalUIContext;
	
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
			
			new ApplicationBootstrap().launch();
			inject(this);
			
			if (texturesStore.isInited)
				hereGo()
			else
				texturesStore.addEventListener(Event.COMPLETE, hereGo);
		}
		
		private function hereGo(e:* = null):void 
		{
			var b:BoomParticle = new BoomParticle();
			
			addChild(b);
			b.x = GlobalUIContext.vectorStage.mouseX;
			b.y = GlobalUIContext.vectorStage.mouseY;
			
			texturesStore.removeEventListener(Event.COMPLETE, hereGo);
			
			removeChild(progressBar);
			removeChild(back);
			
			new GameSceneBuilder(new SceneControllerFactoryImpl, this).buildSceneSequence();

		}
		
	}

}