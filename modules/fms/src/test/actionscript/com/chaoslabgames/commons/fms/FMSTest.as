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
import org.hamcrest.object.sameInstance;

public class FMSTest {

    var fms:FMS = new FMS();

    [Test]
    public function testTransition() {
        fms.state("B")
        fms.state("A").transition("custom_type").toState("B");
        fms.changeState("A");
        assertThat(fms.currentState, equalTo(fms.state("A")));

        fms.handleEvent(new Event("custom_type"));
        assertThat(fms.currentState, equalTo(fms.state("B")));
    }

    [Test]
    public function testDuplicateReferense() {
        assertThat(fms.state("A"), sameInstance(fms.state("A")))
        assertThat(fms.state("A").transition("T"), sameInstance(fms.state("A").transition("T")))
    }

    [Test]
    public function testHandler() {

        var handledEvent:Event;
        var expectedEvent:Event;

        fms.state("A").handler("event_type", function (e:Event):void {
            handledEvent = e;
        });

        fms.changeState("A")
    }
}
}
