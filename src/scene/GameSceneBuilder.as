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

            var lockCtrlr:AbstractSceneController = newController(AppLockedController);
            var licSrvUnAvailblCtrlr:AbstractSceneController = newController(LicenseServerUnAvailableController);
            var gameCntrlr:AbstractSceneController = newController(MainGameController);
            var startCntrlr:AbstractSceneController = newController(StartScreenController);
			
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
                    .addActivateHandler(newSceneFn(lockCtrlr, viewContainer))
                    .addDeactivateHandler(lockCtrlr.deactivate)
                    .addTransition(StateEvents.STATE_OUT).toState('StartScreen')
					
			fsm.state(States.SN_LIC_SERV_UNAVAILABL)
                    .addActivateHandler(newSceneFn(licSrvUnAvailblCtrlr, viewContainer))
                    .addDeactivateHandler(licSrvUnAvailblCtrlr.deactivate)
                    .addTransition(StateEvents.STATE_OUT).toState(States.SN_START_SCREEN)
					
            fsm.state(States.SN_START_SCREEN)
                    .addActivateHandler(newSceneFn(startCntrlr, viewContainer))
                    .addDeactivateHandler(startCntrlr.deactivate)
                    .addTransition(StateEvents.STATE_OUT).toState(States.SN_GAME)

            fsm.state(States.SN_GAME)
                    .addActivateHandler(newSceneFn(gameCntrlr, viewContainer))
                    .addDeactivateHandler(gameCntrlr.deactivate)
                    .addTransition(StateEvents.STATE_OUT).toState(States.SN_START_SCREEN)

            fsm.start();
			

		}

        private function newController(ctrlClass:Class):AbstractSceneController {
            var ctrl:AbstractSceneController = new ctrlClass();
            ctrl.addEventListener(StateEvents.STATE_OUT, fsm.handleEvent);
            return ctrl;
        }

        private function newSceneFn(controller:AbstractSceneController, container:DisplayObjectContainer):Function {
            return function ():void {
                controller.activate(container)
            }
        }
		
	}

}