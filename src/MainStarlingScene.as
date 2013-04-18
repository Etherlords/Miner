package  
{
import com.chaoslabgames.commons.fms.FiniteStateMachine;

import core.scene.AbstractSceneController;

import core.states.config.StateConfig;
	import core.states.State;
	import core.states.StatesManager;
import core.states.events.StateEvents;

import flash.display.DisplayObjectContainer;
import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import logic.MainGameController;
	import logic.StartScreenController;
import logic.license.AppLockedController;

import model.TextureStore;
	import starling.display.DisplayObjectContainer;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import utils.GlobalUIContext;
	
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class MainStarlingScene extends DisplayObjectContainer 
	{
		private var progress:TextField;
		[Inject(id=identinjection)]
		public var texturesStore:TextureStore
		
		[Inject]
		public var test:IEventDispatcher
		
		public function MainStarlingScene() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			new ApplicationBootstrap().launch();
			inject(this);
			
			
			
			
			texturesStore.addEventListener(Event.COMPLETE, hereGo);
			progress = new TextField();
			progress.autoSize = TextFieldAutoSize.LEFT;
			progress.textColor = 0xFFFFFF;
			progress.multiline = true;
			//progress.wordWrap = true;
			progress.border = true;
			progress.borderColor = 0xFFFFFF;
			progress.defaultTextFormat = new TextFormat(null, 20, 0xFFFFFF, true);
			GlobalUIContext.vectorStage.addChild(progress);
			
			texturesStore.preload();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:EnterFrameEvent):void 
		{
			progress.text = texturesStore.getLoadingInfo();
		}
		
		private function hereGo(e:*):void 
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onFrame);
			texturesStore.removeEventListener(Event.COMPLETE, hereGo);
			GlobalUIContext.vectorStage.removeChild(progress);
			
			var fsm:FiniteStateMachine = new FiniteStateMachine();

            var lockController:AppLockedController = newController(AppLockedController);
            var gameController:MainGameController = newController(MainGameController);
            var startController:StartScreenController = newController(StartScreenController);			
			
            fsm.state('locked')
                    .addActivateHandler(newActivateCtrlFn(lockController, this))
                    .addDeactivateHandler(newDeactivateCtrlFn(lockController))
                    .addTransition(StateEvents.STATE_OUT).toState('StartScreen')
            fsm.state('StartScreen')
                    .addActivateHandler(newActivateCtrlFn(startController, this))
                    .addDeactivateHandler(newDeactivateCtrlFn(startController))
                    .addTransition(StateEvents.STATE_OUT).toState('Game')
            fsm.state('Game')
                    .addActivateHandler(newActivateCtrlFn(gameController, this))
                    .addDeactivateHandler(newDeactivateCtrlFn(gameController))
                    .addTransition(StateEvents.STATE_OUT).toState('StartScreen')
            fsm.start();
			
			function newController(ctrlClass:Class):AbstractSceneController {
				var ctrl:AbstractSceneController = new ctrlClass();
				ctrl.addEventListener(StateEvents.STATE_OUT, fsm.handleEvent);
				return ctrl;
			}
		}

        private function newDeactivateCtrlFn(controller:AbstractSceneController):Function {
            return function ():void {
                controller.deactivate()
            }
        }

        private function newActivateCtrlFn(controller:AbstractSceneController, container:DisplayObjectContainer):Function {
            return function ():void {
                controller.activate(container)
            }
        }
		
		
		
	}

}