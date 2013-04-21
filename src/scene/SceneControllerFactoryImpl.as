/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/19/13
 * Time: 10:22 PM
 * To change this template use File | Settings | File Templates.
 */
package scene {
import core.scene.AbstractSceneController;

import logic.MainGameController;
import logic.StartScreenController;

import logic.license.AppLockedController;
import logic.license.LicenseServerUnAvailableController;

public class SceneControllerFactoryImpl implements ISceneControllerFactory{
    public function SceneControllerFactoryImpl() {
    }

    public function newController(id:String):AbstractSceneController {

        var ctrlClass:Class = null;

        switch (id) {
            case StateCnst.SCENE_START_SCREEN:
                ctrlClass = StartScreenController;
                break;
            case StateCnst.SCENE_GAME:
                ctrlClass = MainGameController;
                break;
            case StateCnst.SCENE_LOCKED:
                ctrlClass = AppLockedController;
                break;
            case StateCnst.SCENE_LIC_SERV_UNAVAILABL:
                ctrlClass = LicenseServerUnAvailableController
                break;
            default :
                throw new Error("Unknow scene '" + id + '"')
        }

        return new ctrlClass;
    }
}
}
