package logic.license
{
import core.scene.AbstractSceneController;

import starling.display.DisplayObjectContainer;
import starling.events.Event;

import view.components.Alert;

/**
	 * ...
	 * @author DES
	 */
	public class LicenseServerUnAvailableController extends AbstractSceneController
	{
		
		private var alert:Alert;
		
		private var viewInstance:DisplayObjectContainer;
		
		public function LicenseServerUnAvailableController() {
			
		}
		
		override public function deactivate():void {
			viewInstance.removeChild(alert);	
		}
		
		public override function activate(instance:DisplayObjectContainer):void
		{
			viewInstance = instance;
			
			alert = new Alert()
			
			alert.text = 'server unavailable<br/><button><a href="event:available">available</a></button>\n';
			
			alert.addEventListener('available', startGameHandler);
			
			viewInstance.addChild(alert)
			
			super.initilize();
		}
		
		protected function startGameHandler(e:Event):void {
			exit();
		}
		
	}

}