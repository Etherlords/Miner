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
    private var viewContainer:DisplayObjectContainer;

    public function GameSceneBuilder(sceneControllerFactory:ISceneControllerFactory, viewContainer:DisplayObjectContainer) {
        inject(this);
        fsm = new FiniteStateMachine();
        stateToScene = new Dictionary();
        this.sceneControllerFactory = sceneControllerFactory
        this.viewContainer = viewContainer;
    }


    public function buildSceneSequence():void {

        licService.addEventListener(Cnst.EVENT_APP_IS_UNLOCKED, fsm.handleEvent);
        licService.addEventListener(Cnst.EVENT_APP_IS_LOCKED, fsm.handleEvent);

        bindSceneToState(StateCnst.SCENE_LIC_SERV_UNAVAILABL, StateCnst.STATE_LIC_SERV_UNAVAILABL);
        bindSceneToState(StateCnst.SCENE_START_SCREEN, StateCnst.STATE_START_SCREEN);
        bindSceneToState(StateCnst.SCENE_GAME, StateCnst.STATE_GAME);
        bindSceneToState(StateCnst.SCENE_LOCKED, StateCnst.STATE_LOCKED);

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
                .addTransition(StateEvents.STATE_OUT).toState('StartScreen')

        fsm.state(StateCnst.STATE_LIC_SERV_UNAVAILABL)
                .addTransition(Cnst.EVENT_APP_IS_UNLOCKED).toState(StateCnst.STATE_START_SCREEN)._from
                .addTransition(Cnst.EVENT_APP_IS_LOCKED).toState(StateCnst.STATE_LOCKED)

        fsm.state(StateCnst.STATE_START_SCREEN)
                .addTransition(Cnst.EVENT_APP_IS_LOCKED).toState(StateCnst.STATE_LOCKED)._from
                .addTransition(StateEvents.STATE_OUT).toState(StateCnst.STATE_GAME)

        fsm.state(StateCnst.STATE_GAME)
                .addTransition(Cnst.EVENT_APP_IS_LOCKED).toState(StateCnst.STATE_LOCKED)._from
                .addTransition(StateEvents.STATE_OUT).toState(StateCnst.STATE_START_SCREEN)

        fsm.initState = StateCnst.STATE_CHECK_LIC;
        fsm.start()
    }

    private function bindSceneToState(sceneName:String, stateName:String):void {
        //todo lazy initialization of controller can be added
        var sceneCtrl:AbstractSceneController = newController(sceneName)
        fsm.state(stateName)
                .addActivateHandler(newSceneFn(sceneCtrl))
                .addDeactivateHandler(sceneCtrl.deactivate);

        stateToScene[sceneName] = stateName
    }

    private function newController(sceneName:String):AbstractSceneController {
        if (stateToScene[sceneName]) {
            throw new Error('Scene ' + sceneName + ' have already created')
        }
        var ctrl:AbstractSceneController = sceneControllerFactory.newController(sceneName);
        ctrl.addEventListener(StateEvents.STATE_OUT, fsm.handleEvent);
        return ctrl;
    }

    private function newSceneFn(controller:AbstractSceneController):Function {
        return function ():void {
            controller.activate(viewContainer)
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