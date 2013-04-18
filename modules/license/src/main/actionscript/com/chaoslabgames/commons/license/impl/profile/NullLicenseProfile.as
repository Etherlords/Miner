/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 3/13/13
 * Time: 7:55 AM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.license.impl.profile {
import com.chaoslabgames.commons.license.LicenseProfile;

import flash.events.EventDispatcher;

public class NullLicenseProfile extends EventDispatcher implements LicenseProfile{
    public function NullLicenseProfile() {
    }

    public function request():void {
    }

    public function isLocked():Boolean {
        return false;
    }

    public function isUnLocked():Boolean {
        return true;
    }

    public function marketUrl():String {
        return "";
    }

    public function isCheckServiceUnAvailable():Boolean {
        return false;
    }
}
}
