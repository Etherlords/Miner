/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/17/13
 * Time: 10:41 PM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms {
import flash.events.Event;
import flash.utils.Dictionary;

public class FMS {

    private var states:Dictionary;

    public var currentState:State;

    public function FMS() {
        states = new Dictionary();
    }

    public function state(name:String):State {
        var state:State = states[name];
        if (!state) {
            state = new State();
            states[name] = state;
        }
        return state;
    }

    public function changeState(name:String):void {
        currentState = state(name);
    }

    public function handleEvent(event:Event):void {

    }
}
}
