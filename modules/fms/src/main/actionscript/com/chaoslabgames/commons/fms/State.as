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

    private var _eventHandlers:Dictionary;
    private var _transitions:Dictionary;
    private var _changeStateHandler:Function;

    public var name:String;

    public function State(name:String, changeStateHandler:Function) {
        this.name = name;
        _eventHandlers = new Dictionary()
        _transitions = new Dictionary()
        this._changeStateHandler = changeStateHandler;
    }

    public function transition(eventType:String):Transition {
        var transition:Transition = _transitions[eventType];
        if (transition == null) {
            transition = new Transition(_changeStateHandler);
            _transitions[eventType] = transition;
            handler(eventType, transition.transite)
        }

        return transition;
    }

    public function handler(eventType:String, handler:Function):State {
        eventHandlersByType(eventType).push(handler);
        return this;
    }

    public function handleEvent(event:Event):void {
        var handlers:Array = eventHandlersByType(event.type);
        for (var indx:int = handlers.length; indx > -1; indx--) {
            var targetHandler:Function = handlers[indx];
            if (targetHandler) {
                if (targetHandler.length == 1) {
                    targetHandler(event);
                } else {
                    targetHandler();
                }
            }
        }
    }

    private function eventHandlersByType(eventType:String):Array {
        var handlers:Array = _eventHandlers[eventType];
        if (!handlers) {
            handlers = [];
            _eventHandlers[eventType] = handlers;
        }
        return handlers;
    }

    public function toString():String {
        return "[" + name + "]";
    }
}
}
