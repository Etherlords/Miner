/*

ADOBE SYSTEMS INCORPORATED
Copyright 2011 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.

*/

package com.adobe.nativeExtensions
{
	import flash.utils.getDefinitionByName;
	public class Vibration
	{
		// If the AIR application creates multiple Vibration objects,
		// all the objects share one instance of the ExtensionContext class.
		private static var extContext:Object = null;
		private static var ExtensionContext:Object;
		
		public function Vibration()
		{
			
			
			// If the one instance of the ExtensionContext class has not
			// yet been created, create it now.
			ExtensionContext = getDefinitionByName('flash.external.ExtensionContext');
			
			if (!extContext)
			{
				initExtension();
			}
		}
		
		public static function get isSupported():Boolean
		{
			// Because this is a static function, create the ExtensionContext object, if necessary.
			if (!extContext)
			{	
				initExtension();
			}
			
			return extContext? extContext.call("isSupported") as Boolean:false;
		}
		
		//Initialize the extension by calling our "initNativeCode" ANE function
		private static function initExtension():void
		{
			
			// The extension context's context type  is NULL, because this extension
			// has only one context type.
			
			try
			{
				extContext = ExtensionContext.createExtensionContext("com.adobe.Vibration", null);
				extContext.call("initNativeCode");
			}catch (e:Error)
			{
				
			}
		}
		
		public function vibrate(duration:Number):void
		{
			
			
			// Note that the duration value, in milliseconds, applies to the Android implementation, but not
			// to the iOS implementation. The iOS implementation ignores the duration value.
			
			extContext.call("vibrateDevice", duration);
		}
	}
}