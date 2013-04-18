package  
{
import com.chaoslabgames.commons.license.impl.LicenseService;

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

            var licenseService:LicenseService = new LicenseService();

			context.addObjectToContext(textureStore, 'identinjection');
			context.addObjectToContext(licenseService);
			
			context.init();
		}
		
	}

}