/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/17/13
 * Time: 10:46 PM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms {
import flash.events.Event;
import flash.utils.Dictionary;

public class State {

    private var _transitions:Dictionary;
    private var _changeStateHandler:Function;

    public function State(changeStateHandler:Function) {
        _transitions = new Dictionary()
        this._changeStateHandler = changeStateHandler;
    }

    public function transition(eventType:String):Transition {
        var transition:Transition = _transitions[eventType];
        if (transition == null) {
            transition = new Transition();
            _transitions[eventType] = transition;
        }

        return transition;
    }


    public function handleEvent(event:Event):void {
        var trans:Transition = transition(event.type);
        if (trans) {
            _changeStateHandler(trans.state);
        }
    }
}
}
