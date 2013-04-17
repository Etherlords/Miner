/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/17/13
 * Time: 10:19 PM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms {
import flash.events.Event;

import org.flexunit.asserts.assertFalse;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class FMSTest {
    [Test]
    public function testTransition() {
        var fms:FMS = new FMS();
        fms.state("B")
        //fms.state("A").transition("custom_type").toState("B")
        fms.changeState("A");
        assertThat(fms.currentState, equalTo(fms.state("A")))
        fms.handleEvent(new Event("custom_type"));
        assertThat(fms.currentState, equalTo(fms.state("B")))
    }
}
}
