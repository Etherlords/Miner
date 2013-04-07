package particles.starParticles
{
	import flash.display3D.Context3DBlendFactor;
	import model.TextureStore;
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;

	public class StarParticlesEmmiter extends PDParticleSystem 
	{
		[Embed(source="particle.pex", mimeType="application/octet-stream")]
		private var InitValues:Class
		
		[Inject]
		public var textureStore:TextureStore
		
		public function StarParticlesEmmiter() 
		{
			inject(this);
			super(	XML(new InitValues()), textureStore.getTexture('starParticle')		);
			
			blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA, 
			blendFactorDestination =  Context3DBlendFactor.ONE
			
			test();
		}
		
		private function test():void
		{
			start();
			
			maxNumParticles = 200;
			emitterXVariance = 800;
			
			
			
			Starling.juggler.add(this);
		}
		
	}

}