package particles.starParticles
{
	import core.services.ServicesLocator;
	import flash.display3D.Context3DBlendFactor;
	import model.TextureStore;
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class StarParticlesEmmiter extends PDParticleSystem 
	{
		
		
		[Embed(source="particle.pex", mimeType="application/octet-stream")]
		private var InitValues:Class
		private var textureStore:TextureStore = ServicesLocator.instance.getService(TextureStore) as TextureStore;
		
		public function StarParticlesEmmiter() 
		{
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