package particles.boomParticle
{
	import flash.display3D.Context3DBlendFactor;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class BoomParticle extends PDParticleSystem 
	{
		
		
		[Embed(source="particle.pex", mimeType="application/octet-stream")]
		private var InitValues:Class
		
		[Embed(source = "texture.png")]
		private var Sample:Class
		
		public function BoomParticle() 
		{
			super(	XML(new InitValues()), Texture.fromBitmap(new Sample(), false, true)		);
			
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