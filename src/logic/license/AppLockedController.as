package logic.license
{
	import core.scene.AbstractSceneController;
	import logic.*;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import view.components.Alert;
	
	/**
	 * ...
	 * @author DES
	 */
	public class AppLockedController extends AbstractSceneController
	{
		
		private var alert:Alert;
		
		private var viewInstance:DisplayObjectContainer;
		
		public function AppLockedController()
		{
		
		}
		
		override public function deactivate():void
		{
			viewInstance.removeChild(alert);
		}
		
		public override function activate(instance:DisplayObjectContainer):void
		{
			viewInstance = instance;
			
			alert = new Alert()
			
			alert.text = 'Game locked<br/><button><a href="event:unlock">unlock</a></button>\n';
			
			alert.addEventListener('unlock', startGameHandler);
			
			viewInstance.addChild(alert)
			
			super.initilize();
		}
		
		protected function startGameHandler(e:Event):void
		{
			exit();
		}
	
	}

}