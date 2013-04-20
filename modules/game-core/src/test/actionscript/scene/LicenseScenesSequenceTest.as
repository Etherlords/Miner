/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/19/13
 * Time: 8:20 AM
 * To change this template use File | Settings | File Templates.
 */
package scene {

import com.chaoslabgames.commons.fms.FiniteStateMachine;
import com.chaoslabgames.commons.license.Cnst;
import com.chaoslabgames.commons.license.impl.LicenseService;
import core.ioc.Context;
import flash.events.DataEvent;

import model.TextureStore;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

[RunWith("org.flexunit.runners.Parameterized")]
public class LicenseScenesSequenceTest {

    private var licService:LicenseService;
    private var licProfile:MockLicProfile
    private var gameSceneBuilder:GameSceneBuilder;
    private var sceneFactory:MockSceneCtrlFactory

    //todo it must be scene keys only
    public static function lockableStatesDataProvider():Array {
        return [
        [StateCnst.STATE_LIC_SERV_UNAVAILABL, StateCnst.SCENE_LIC_SERV_UNAVAILABL],
        [StateCnst.STATE_START_SCREEN, StateCnst.SCENE_START_SCREEN],
        [StateCnst.STATE_GAME, StateCnst.SCENE_GAME]];
    }

    [Before]
    public function setUp():void {
        var context:Context = Context.instance;
        licService = new LicenseService();
        licProfile = new MockLicProfile();
        licService.licenseCheckHandler = licProfile
        context.addObjectToContext(licService)
        context.addObjectToContext(new TextureStore())
        sceneFactory = new MockSceneCtrlFactory;
        gameSceneBuilder = new GameSceneBuilder(sceneFactory)
    }

    [Test]
    public function testSetUp():void {
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer());
    }

    [Test]
    public function testAlreadyUnlocked():void {
        //given
        licProfile.locked = false;
        licProfile.serviceAvailable = true;
        //when
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer());
        //then
        var startScreenCtrl:MockSceneController = sceneCtrl(StateCnst.SCENE_START_SCREEN)
        assertThat(startScreenCtrl.active, equalTo(true))
    }

    [Test]
    public function testAlreadyLocked():void {
        //given
        licProfile.locked = true;
        licProfile.serviceAvailable = true;
        //when
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer());
        //then
        var lockedSceneCtrl:MockSceneController = sceneCtrl(StateCnst.SCENE_LOCKED)
        assertThat(lockedSceneCtrl.active, equalTo(true))
    }

    [Test]
    public function testServUnAvailable():void {
        //given
        licProfile.serviceAvailable = false;
        //when
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer());
        //then
        var srvUnAvailblSceneCtrl:MockSceneController = sceneCtrl(StateCnst.SCENE_LIC_SERV_UNAVAILABL)
        assertThat(srvUnAvailblSceneCtrl.active, equalTo(true))
    }

    [Test]
    public function testTransitionFromUnAvailableToUnLock():void {
        //given
        licProfile.serviceAvailable = false;
        //when
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer())
        assertThat(sceneCtrl(StateCnst.SCENE_LIC_SERV_UNAVAILABL).active, equalTo(true))
        //turn on service and unlock
        licProfile.serviceAvailable = true;
        licProfile.locked = false;
        licProfile.dispatchEvent(new DataEvent(Cnst.EVENT_APP_IS_UNLOCKED));
        //then
        assertThat(sceneCtrl(StateCnst.SCENE_LIC_SERV_UNAVAILABL).active, equalTo(false))
        assertThat(sceneCtrl(StateCnst.SCENE_START_SCREEN).active, equalTo(true))
    }

    private function sceneCtrl(id:String):MockSceneController {
        return sceneFactory.constructedMockScenes[id]
    }

    [Test]
    public function testTransitionFromUnAvailableToLock():void {
        //given
        licProfile.serviceAvailable = false;
        //when
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer())
        assertThat(sceneCtrl(StateCnst.SCENE_LIC_SERV_UNAVAILABL).active, equalTo(true))
        //turn on service and unlock
        licProfile.serviceAvailable = true;
        licProfile.locked = true;
        licProfile.dispatchEvent(new DataEvent(Cnst.EVENT_APP_IS_LOCKED));
        //then
        assertThat(sceneCtrl(StateCnst.SCENE_LIC_SERV_UNAVAILABL).active, equalTo(false))
        assertThat(sceneCtrl(StateCnst.SCENE_LOCKED).active, equalTo(true))
    }

    [Test(dataProvider="lockableStatesDataProvider")]
    public function testTransitionFromLockableStatesToLockState(fromStateName:String, sceneName:String):void {
        //given
        licProfile.serviceAvailable = true;
        licProfile.locked = false; //because check is running in background
        //then
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer())
        gameSceneBuilder.sceneFSM.changeState(fromStateName);
        assertThat(sceneCtrl(sceneName).active, equalTo(true))
        licProfile.locked = true;
        licProfile.dispatchEvent(new DataEvent(Cnst.EVENT_APP_IS_LOCKED));
        //when
        assertThat(sceneCtrl(StateCnst.SCENE_START_SCREEN).active, equalTo(false))
        assertThat(sceneCtrl(StateCnst.SCENE_LOCKED).active, equalTo(true))
    }
}

}

import com.chaoslabgames.commons.license.LicenseProfile;

import core.scene.AbstractSceneController;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import scene.ISceneControllerFactory;

import starling.display.DisplayObjectContainer;

internal class MockSceneCtrlFactory implements ISceneControllerFactory{

    public var constructedMockScenes:Dictionary = new Dictionary();

    public function newController(id:String):AbstractSceneController {
        return constructedMockScenes[id] = new MockSceneController();

    }
}

internal class MockSceneController extends AbstractSceneController {

    override public function activate(instance:DisplayObjectContainer):void {
        isActivated = true;
    }

    override public function deactivate():void {
        isActivated = false;
    }

    public function get active():Boolean {
        return isActivated
    }
}

internal class MockLicProfile extends EventDispatcher implements LicenseProfile {

    public var locked:Boolean = true;
    public var serviceAvailable:Boolean = true;

    public function request():void {
    }

    public function isLocked():Boolean {
        return locked;
    }

    public function isUnLocked():Boolean {
        return !locked;
    }

    public function marketUrl():String {
        return "";
    }

    public function isCheckServiceUnAvailable():Boolean {
        return !serviceAvailable;
    }
}

internal class MockDisplayObjectContainer extends DisplayObjectContainer {
}
