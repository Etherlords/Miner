/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/19/13
 * Time: 8:20 AM
 * To change this template use File | Settings | File Templates.
 */
package scene {

import com.chaoslabgames.commons.fms.FiniteStateMachine;
import com.chaoslabgames.commons.license.LicenseProfile;
import com.chaoslabgames.commons.license.impl.LicenseService;
import com.chaoslabgames.commons.license.impl.profile.NullLicenseProfile;

import core.ioc.Context;

import model.TextureStore;

public class LicenseScenesSequenceTest {


    private var fsm:FiniteStateMachine;
    private var licService:LicenseService;
    private var licProfile:LicenseProfile
    private var gameSceneBuilder:GameSceneBuilder;

    [Before]
    public function setUp():void {
        var context:Context = Context.instance;
        licService = new LicenseService();
        licProfile = new NullLicenseProfile();
        licService.licenseCheckHandler = licProfile
        context.addObjectToContext(licService)
        context.addObjectToContext(new TextureStore())
        gameSceneBuilder = new GameSceneBuilder(new MockSceneCtrlFactory)
    }

    [Test]
    public function testSetUp():void {
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer());
    }
}

}

import core.scene.AbstractSceneController;

import scene.ISceneControllerFactory;

import starling.display.DisplayObjectContainer;

internal class MockSceneCtrlFactory implements ISceneControllerFactory{

    public function newController(id:String):AbstractSceneController {
        return new MockSceneController();
    }
}

internal class MockSceneController extends AbstractSceneController {
    override public function activate(instance:DisplayObjectContainer):void {
    }

    override public function deactivate():void {
    }
}

internal class MockDisplayObjectContainer extends DisplayObjectContainer {

}
