package particles.curosrParticle
{
	import flash.display3D.Context3DBlendFactor;
	import model.TextureStore;
	import starling.core.Starling;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class CursorParticle extends PDParticleSystem 
	{
		
		
		[Embed(source="particle.pex", mimeType="application/octet-stream")]
		private var InitValues:Class
		
		
		public function CursorParticle() 
		{
			super(	XML(new InitValues()), TextureStore.texturesAtlas.getTexture('starParticle')		);
			
			blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA, 
			blendFactorDestination =  Context3DBlendFactor.ONE
			
			test();
		}
		
		private function test():void
		{
			start();
			
			maxNumParticles = 150;
			
			
			
			
			Starling.juggler.add(this);
		}
		
	}

}