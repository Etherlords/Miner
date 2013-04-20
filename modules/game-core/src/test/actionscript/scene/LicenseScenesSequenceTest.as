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

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class LicenseScenesSequenceTest {


    private var fsm:FiniteStateMachine;
    private var licService:LicenseService;
    private var licProfile:MockLicProfile
    private var gameSceneBuilder:GameSceneBuilder;
    private var sceneFactory:MockSceneCtrlFactory

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
        var startScreenCtrl:MockSceneController = sceneFactory.constructedMockScenes[StateCnst.SCENE_START_SCREEN]
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
        var lockedSceneCtrl:MockSceneController = sceneFactory.constructedMockScenes[StateCnst.SCENE_LOCKED]
        assertThat(lockedSceneCtrl.active, equalTo(true))
    }

    [Test]
    public function testServUnAvailable():void {
        //given
        licProfile.serviceAvailable = false;
        //when
        gameSceneBuilder.buildSceneSequence(new MockDisplayObjectContainer());
        //then
        var srvUnAvailblSceneCtrl:MockSceneController = sceneFactory.constructedMockScenes[StateCnst.SCENE_LIC_SERV_UNAVAILABL]
        assertThat(srvUnAvailblSceneCtrl.active, equalTo(true))
    }
}

}

import com.chaoslabgames.commons.license.LicenseProfile;

import core.scene.AbstractSceneController;

import flash.events.Event;
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

internal class MockLicProfile implements LicenseProfile {

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

    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
    }

    public function dispatchEvent(event:Event):Boolean {
        return false;
    }

    public function hasEventListener(type:String):Boolean {
        return false;
    }

    public function willTrigger(type:String):Boolean {
        return false;
    }
}

internal class MockDisplayObjectContainer extends DisplayObjectContainer {

}
