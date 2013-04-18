/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 3/13/13
 * Time: 7:52 AM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.license {
import flash.events.IEventDispatcher;

public interface LicenseProfile extends IEventDispatcher {
    function request():void;
    function isLocked():Boolean;
    function isUnLocked():Boolean;
    function marketUrl():String;
    function isCheckServiceUnAvailable():Boolean;
}

}
