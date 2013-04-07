package particles.boomParticle
{
	import model.TextureStore;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;

	public class BoomParticle extends PDParticleSystem 
	{
		
		
		[Embed(source="particle.pex", mimeType="application/octet-stream")]
		private var InitValues:Class
		
		[Inject]
		public var textureStore:TextureStore
		
		public function BoomParticle() 
		{
			inject(this);
			super(	XML(new InitValues()), textureStore.getTexture('starParticle')		);
			
			maxNumParticles = 500;
			this.alpha = 5;
			Starling.juggler.add(this);
			addEventListener(Event.ADDED_TO_STAGE, test);
		}
		
		private function test(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, test);
			
			
		//	
		
			
			start(0.2);
			advanceTime(0.5);
			
			
			
			
			
			
			//addEventListener(EnterFrameEvent.ENTER_FRAME, loop);
		}
		
		private function loop(e:EnterFrameEvent):void 
		{
			if (numParticles == 0)
			{
				stop();
				Starling.juggler.remove(this);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}