/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/19/13
 * Time: 8:20 AM
 * To change this template use File | Settings | File Templates.
 */
package scene {

import com.chaoslabgames.commons.fms.FiniteStateMachine;
import com.chaoslabgames.commons.license.impl.LicenseService;

import core.ioc.Context;

import model.TextureStore;

public class LicenseScenesSequenceTest {


    private var fsm:FiniteStateMachine;

    [Before]
    public function setUp():void {
        var context:Context = Context.instance;
        context.addObjectToContext(new LicenseService())
        context.addObjectToContext(new TextureStore())
    }

    [Test]
    public function testSetUp():void {
        new GameSceneBuilder().buildSceneSequence(new MockDisplayObjectContainer());
    }
}

}

import starling.display.DisplayObjectContainer;

internal class MockDisplayObjectContainer extends DisplayObjectContainer {

}
