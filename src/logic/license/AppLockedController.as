package logic.license
{
import logic.*;
	import core.scene.AbstractSceneController;
	import core.ui.KeyBoardController;
	import flash.display.StageDisplayState;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import logic.MineFieldBuilder;
	import model.Alerts;
	import model.CellConstants;
	import model.GameModel;
	import model.MineFieldCellModel;
	import model.MineFieldModel;
	import model.SettingsModel;
	import particles.boomParticle.BoomParticle;
	import particles.curosrParticle.CursorParticle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.filters.BlurFilter;
	import utils.GlobalUIContext;
	import view.components.Alert;
	import view.MainGaimView;
	
	
	/**
	 * ...
	 * @author DES
	 */
	public class AppLockedController extends AbstractSceneController 
	{
		
		private var alert:Alert;
		
		private var viewInstance:DisplayObjectContainer;
		
		public function AppLockedController() {
			
		}
		
		override public function deactivate():void {
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
		
		protected function startGameHandler(e:Event):void {
			exit();
		}
		
	}

}