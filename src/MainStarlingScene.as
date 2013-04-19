package  
{
	import feathers.controls.ProgressBar;
	import flash.events.IEventDispatcher;
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
	import view.theme.ProgressBarInitilizer;
	
	public class MainStarlingScene extends DisplayObjectContainer 
	{
		private var progress:TextField;
		private var progressBar:ProgressBar;
		private var back:Image;
		[Inject(id=identinjection)]
		public var texturesStore:TextureStore
		
		[Inject]
		public var test:IEventDispatcher
		
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
			
			new ProgressBarInitilizer()
			
			back = new Image(MinimalAsset.loadBgTexture);
			addChild(back);
			
			back.x = (stage.stageWidth - back.width) / 2;
			back.y = (stage.stageHeight - back.height) / 2;
			
			progressBar = new ProgressBar();
			progressBar.width = stage.stageWidth / 1.5;
			progressBar.x = (stage.stageWidth - progressBar.width) / 2;
			progressBar.y = stage.stageHeight - 200;
			addChild(progressBar);
			
			texturesStore.addEventListener(Event.COMPLETE, hereGo);
			texturesStore.addEventListener('progress', onLoadProgress);
			texturesStore.preload();
			
		}
		
		private function onLoadProgress(e:*):void 
		{
			/*r['percent'] = progress? progress.bytesLoaded / progress.bytesTotal : 0;
			r['currentlyLoad'] = currentFiled;
			r['bytesTottal'] = progress? progress.bytesTotal:0
			r['bytesLoaded'] = progress? progress.bytesLoaded:0
			r['overallProgress'] = progress? progress.bytesLoaded:0
			*/
			
			var r:Object = texturesStore.getLoadingInfo();
			
			var twe:Tween = new Tween(progressBar, 0.2);
			twe.animate('value', r.overallProgress);
			Starling.current.juggler.add(twe);
		}
		
		private function hereGo(e:*):void 
		{
			var b:BoomParticle = new BoomParticle();
			
			addChild(b);
			b.x = GlobalUIContext.vectorStage.mouseX;
			b.y = GlobalUIContext.vectorStage.mouseY;
			
			texturesStore.removeEventListener(Event.COMPLETE, hereGo);
			
			removeChild(progressBar);
			removeChild(back);
			
			new GameSceneBuilder(new SceneControllerFactoryImpl).buildSceneSequence(this);

		}
		
	}

}