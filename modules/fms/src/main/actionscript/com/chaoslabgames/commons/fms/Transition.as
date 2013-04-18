/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/18/13
 * Time: 6:46 AM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms {
public class Transition {

    public var state:String;
    private var changeStateHandler:Function;
    public function Transition(changeStateHandler:Function) {
        this.changeStateHandler = changeStateHandler;
    }

    public function toState(state:String):Transition {
        this.state = state;
        return this
    }

    public function transite():void {
        changeStateHandler(state);
    }
}
}
