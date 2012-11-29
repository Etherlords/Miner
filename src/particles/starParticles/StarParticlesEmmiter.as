package particles.starParticles
{
	import flash.display3D.Context3DBlendFactor;
	import model.TextureStore;
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class StarParticlesEmmiter extends PDParticleSystem 
	{
		
		
		[Embed(source="particle.pex", mimeType="application/octet-stream")]
		private var InitValues:Class
		
		
		public function StarParticlesEmmiter() 
		{
			super(	XML(new InitValues()), TextureStore.starParticle		);
			
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