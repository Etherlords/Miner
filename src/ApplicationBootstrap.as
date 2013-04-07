package  
{
	import core.ioc.Context;
	import model.TextureStore;
	/**
	 * ...
	 * @author Nikro
	 */
	public class ApplicationBootstrap 
	{
		
		public function ApplicationBootstrap() 
		{
			
		}
		
		public function launch():void
		{
			var context:Context = Context.instance;
				
			var textureStore:TextureStore = new TextureStore();
			
			context.addObjectToContext(textureStore);
			
			
			context.init();
		}
		
	}

}