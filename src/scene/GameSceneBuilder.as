package scene {
import com.chaoslabgames.commons.fms.FiniteStateMachine;
import com.chaoslabgames.commons.fms.events.StateEvent;
import com.chaoslabgames.commons.license.Cnst;
import com.chaoslabgames.commons.license.impl.LicenseService;

import core.scene.AbstractSceneController;
import core.states.events.StateEvents;

import flash.utils.Dictionary;

import starling.display.DisplayObjectContainer;

/**
 * ...
 * @author DES
 */
public class GameSceneBuilder {

    [Inject]
    public var licService:LicenseService;

    private var fsm:FiniteStateMachine;

    private var sceneControllerFactory:ISceneControllerFactory;

    private var stateToScene:Dictionary;

    public function GameSceneBuilder(sceneControllerFactory:ISceneControllerFactory) {
        inject(this);
        fsm = new FiniteStateMachine();
        stateToScene = new Dictionary();
        this.sceneControllerFactory = sceneControllerFactory
    }


    public function buildSceneSequence(viewContainer:DisplayObjectContainer):void {

        var lockCtrlr:AbstractSceneController = newController(StateCnst.SCENE_LOCKED);
        var licSrvUnAvailblCtrlr:AbstractSceneController = newController(StateCnst.SCENE_LIC_SERV_UNAVAILABL);
        var gameCntrlr:AbstractSceneController = newController(StateCnst.SCENE_GAME);
        var startCntrlr:AbstractSceneController = newController(StateCnst.SCENE_START_SCREEN);

        licService.addEventListener(Cnst.EVENT_APP_IS_UNLOCKED, fsm.handleEvent);
        licService.addEventListener(Cnst.EVENT_APP_IS_LOCKED, fsm.handleEvent);

        stateToScene[StateCnst.SCENE_LIC_SERV_UNAVAILABL] = StateCnst.STATE_LIC_SERV_UNAVAILABL
        stateToScene[StateCnst.SCENE_START_SCREEN] = StateCnst.STATE_START_SCREEN
        stateToScene[StateCnst.SCENE_GAME] = StateCnst.STATE_GAME

        fsm.state(StateCnst.STATE_CHECK_LIC)
                .addTransition(StateEvent.EVENT_TYPE_ACTIVATE, "licServUnAvailbl")
                        .addConditional(licService.licenseCheckHandler.isCheckServiceUnAvailable)
                    .toState(StateCnst.STATE_LIC_SERV_UNAVAILABL)._from
                .addTransition(StateEvent.EVENT_TYPE_ACTIVATE, "alreadyUnclocked")
                        .addConditional(licService.licenseCheckHandler.isUnLocked)
                    .toState(StateCnst.STATE_START_SCREEN)._from
                .addTransition(StateEvent.EVENT_TYPE_ACTIVATE, "alredyLocked")
                        .addConditional(licService.licenseCheckHandler.isLocked)
                    .toState(StateCnst.STATE_LOCKED)

        fsm.state(StateCnst.STATE_LOCKED)
                .addActivateHandler(newSceneFn(lockCtrlr, viewContainer))
                .addDeactivateHandler(lockCtrlr.deactivate)
                .addTransition(StateEvents.STATE_OUT).toState('StartScreen')

        fsm.state(StateCnst.STATE_LIC_SERV_UNAVAILABL)
                .addActivateHandler(newSceneFn(licSrvUnAvailblCtrlr, viewContainer))
                .addDeactivateHandler(licSrvUnAvailblCtrlr.deactivate)
                .addTransition(Cnst.EVENT_APP_IS_UNLOCKED).toState(StateCnst.STATE_START_SCREEN)._from
                .addTransition(Cnst.EVENT_APP_IS_LOCKED).toState(StateCnst.STATE_LOCKED)

        fsm.state(StateCnst.STATE_START_SCREEN)
                .addActivateHandler(newSceneFn(startCntrlr, viewContainer))
                .addDeactivateHandler(startCntrlr.deactivate)
                .addTransition(Cnst.EVENT_APP_IS_LOCKED).toState(StateCnst.STATE_LOCKED)._from
                .addTransition(StateEvents.STATE_OUT).toState(StateCnst.STATE_GAME)

        fsm.state(StateCnst.STATE_GAME)
                .addActivateHandler(newSceneFn(gameCntrlr, viewContainer))
                .addDeactivateHandler(gameCntrlr.deactivate)
                .addTransition(Cnst.EVENT_APP_IS_LOCKED).toState(StateCnst.STATE_LOCKED)._from
                .addTransition(StateEvents.STATE_OUT).toState(StateCnst.STATE_START_SCREEN)

        fsm.start();


    }

    public function get sceneFSM():FiniteStateMachine {
        return fsm;
    }

    private function newController(stateName:String):AbstractSceneController {
        var ctrl:AbstractSceneController = sceneControllerFactory.newController(stateName);
        ctrl.addEventListener(StateEvents.STATE_OUT, fsm.handleEvent);
        return ctrl;
    }

    private function newSceneFn(controller:AbstractSceneController, container:DisplayObjectContainer):Function {
        return function ():void {
            controller.activate(container)
        }
    }

    public function changeActiveSceneHandler(sceneName:String):void {
        var targetStateName:String = stateToScene[sceneName]
        if (!targetStateName) {
            throw new Error("State couldn't be found for scene '" + sceneName + "'")
        }
        fsm.changeState(targetStateName)
    }
}

}