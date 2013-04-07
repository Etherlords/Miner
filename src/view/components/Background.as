package view.components 
{
	import model.TextureStore;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class Background extends Sprite 
	{
		[Inject]
		public var textureStore:TextureStore
		private var bg2:Image;
		private var bg1:Image;
		
		public function Background() 
		{
			inject(this);
			super();
			
			initilize();
		}
		
		private function initilize():void 
		{
			bg1 = new Image(textureStore.getTexture('bg2.png'));
			bg2 = new Image(textureStore.getTexture('bg2.png'));
			
			addChild(bg1);
			addChild(bg2);
			bg1.alpha = 0.5;
			//bg2.rotation = 90;
			fadeOut();
			
			
		}
		
		private function fadeOut():void
		{
			var tween:Tween = new Tween(bg2, 5);
			tween.animate('alpha', 0.5);
			
			tween.onComplete = fadeUp
			
			Starling.juggler.add(tween);
		}
		
		private function fadeUp():void
		{
			var tween:Tween = new Tween(bg2, 5);
			tween.animate('alpha', 2);
			
			tween.onComplete = fadeOut
			Starling.juggler.add(tween);
			
		}
		
	}

}