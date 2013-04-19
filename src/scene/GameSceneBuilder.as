package scene {
import com.chaoslabgames.commons.fms.FiniteStateMachine;
import com.chaoslabgames.commons.fms.events.StateEvent;
import com.chaoslabgames.commons.license.impl.LicenseService;

import core.scene.AbstractSceneController;
import core.states.events.StateEvents;

import logic.MainGameController;
import logic.StartScreenController;

import logic.license.AppLockedController;
import logic.license.LicenseServerUnAvailableController;

import scene.States;

import scene.States;

import scene.States;

import scene.States;

import scene.States;

import scene.States;

import scene.States;

import starling.display.DisplayObjectContainer;

/**
	 * ...
	 * @author DES
	 */
	public class GameSceneBuilder 
	{

        [Inject]
        public var licService:LicenseService;

        private var fsm:FiniteStateMachine = new FiniteStateMachine();

        public function GameSceneBuilder()
		{
			inject(this);
		}
		
		
		public function buildSceneSequence(viewContainer:DisplayObjectContainer):void {

            var lockController:AbstractSceneController = newController(AppLockedController);
            var licSrvUnAvailableController:AbstractSceneController = newController(LicenseServerUnAvailableController);
            var gameController:AbstractSceneController = newController(MainGameController);
            var startController:AbstractSceneController = newController(StartScreenController);
			
			fsm.state(States.SN_CHECK_LIC)
                    .addTransition(StateEvent.EVENT_TYPE_ACTIVATE, "alreadyUnclocked")
							.addConditional(licService.licenseCheckHandler.isUnLocked)
						.toState(States.SN_START_SCREEN)._from
					.addTransition(StateEvent.EVENT_TYPE_ACTIVATE, "alredyLocked")
							.addConditional(licService.licenseCheckHandler.isUnLocked)
						.toState(States.SN_LOCKED)._from
					.addTransition(StateEvent.EVENT_TYPE_ACTIVATE, "licServUnAvailbl")
							.addConditional(licService.licenseCheckHandler.isCheckServiceUnAvailable)
						.toState(States.SN_LIC_SERV_UNAVAILABL)
			
            fsm.state(States.SN_LOCKED)
                    .addActivateHandler(newActSceneFn(lockController, viewContainer))
                    .addDeactivateHandler(lockController.deactivate)
                    .addTransition(StateEvents.STATE_OUT).toState('StartScreen')
					
			fsm.state(States.SN_LIC_SERV_UNAVAILABL)
                    .addActivateHandler(newActSceneFn(licSrvUnAvailableController, viewContainer))
                    .addDeactivateHandler(licSrvUnAvailableController.deactivate)
                    .addTransition(StateEvents.STATE_OUT).toState(States.SN_START_SCREEN)
					
            fsm.state(States.SN_START_SCREEN)
                    .addActivateHandler(newActSceneFn(startController, viewContainer))
                    .addDeactivateHandler(startController.deactivate)
                    .addTransition(StateEvents.STATE_OUT).toState(States.SN_GAME)

            fsm.state(States.SN_GAME)
                    .addActivateHandler(newActSceneFn(gameController, viewContainer))
                    .addDeactivateHandler(gameController.deactivate)
                    .addTransition(StateEvents.STATE_OUT).toState(States.SN_START_SCREEN)

            fsm.start();
			

		}

        private function newController(ctrlClass:Class):AbstractSceneController {
            var ctrl:AbstractSceneController = new ctrlClass();
            ctrl.addEventListener(StateEvents.STATE_OUT, fsm.handleEvent);
            return ctrl;
        }

        private function newActSceneFn(controller:AbstractSceneController, container:DisplayObjectContainer):Function {
            return function ():void {
                controller.activate(container)
            }
        }
		
	}

}