package
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import starling.core.Starling;
	import utils.GlobalUIContext;
	
	
	
	
	public class StarlingInit extends Sprite
	{
		private var mStarling:Starling;
		
		private var stageWidth:Number = 0;
		private var stageHeight:Number = 0;
		private var driver:TextField;
		

		public function StarlingInit()
		{
			
			
			initilizeContext();
			
			stage.align = 'TL';
			stage.scaleMode = 'noScale';
			
			
			Starling.handleLostContext = true; // deactivate on mobile devices (to save memory)
			
			//TweenPlugin.activate([ColorTransformPlugin, TintPlugin]);


			var cursor:MouseCursorData = new MouseCursorData();
			cursor.data = new <BitmapData>[new BitmapData(1, 1, true, 0x01000000)];
			Mouse.registerCursor('noCursor', cursor);

			
			mStarling = new Starling(MainStarlingScene, stage, new Rectangle(0, 0, 1024, 768), null, Context3DRenderMode.AUTO, 'baseline');
			
			stage.addEventListener(Event.RESIZE, onFullScreen);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenEvent);
			mStarling.simulateMultitouch = false;
			mStarling.antiAliasing = 4;
			mStarling.enableErrorChecking = false;
			
			mStarling.start();
			mStarling.showStats = false;
			mStarling.showStatsAt('right','bottom');
			
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			//stage.quality = StageQuality.HIGH_16X16_LINEAR
			
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			
			
			
			
			//addChild(new TheMiner());
		}
		
		private function fullScreenEvent(e:FullScreenEvent):void 
		{
			if (e.fullScreen)
			{
				var scale:Number = stage.fullScreenHeight / 768;
				stage.fullScreenSourceRect = new Rectangle(0, 0, 1024 * scale, 768 * scale);
				mStarling.antiAliasing = 1;
			}
			else 
			{
				mStarling.antiAliasing = 4;
				stage.fullScreenSourceRect =  null;// new Rectangle(0, 0, stageWidth, stageHeight);
			}
		}
		
		private function onFullScreen(e:Event):void 
		{
			
			if(stage.displayState == StageDisplayState.NORMAL)
			{
				Starling.current.root.x = (stageWidth - 1024) / 2;
				Starling.current.root.y = (stageHeight - 768) / 2;
				Starling.current.viewPort = new Rectangle(Starling.current.root.x, Starling.current.root.y, 1024, 768);
				trace(Starling.current.root.x, Starling.current.root.y, Starling.current.nativeStage.stageWidth);
				Starling.current.root.x = 10
				Starling.current.root.y = 0
				driver.x = stage.stageWidth - driver.textWidth - 2;
				
				return;
			}
			
			var scale:Number = stage.fullScreenHeight / 768;
			var __x:Number
			var __y:Number
			__x = 0//(Starling.current.nativeStage.fullScreenWidth - 800 * scale) / 2;
			__y = (Starling.current.nativeStage.fullScreenHeight - 768 * scale) / 2;
			trace(__x, __y);
			//Starling.current.root.y = (Starling.current.nativeStage.stageHeight - 600) / 2;
			mStarling.viewPort = new Rectangle( __x, __y, 1024 * scale, 768 * scale);
			mStarling.root.x = 10;
			
			
			//mStarling.root.y = 0
			//mStarling.root.scaleX = 0.9
			
			driver.x = stage.fullScreenWidth - driver.textWidth - 2;
			
			//mStarling.root.scaleY = mStarling.root.scaleX = scale;
			
			//mStarling.root.scaleX = mStarling.root.scaleY = 2;
		}
		
		private function initilizeContext():void 
		{
			var topcontainer:DisplayObjectContainer = new Sprite();
			var debugContainer:DisplayObjectContainer = new Sprite();
			topcontainer.addChild(debugContainer);
			
			stage.addChild(topcontainer);
			
			GlobalUIContext.debugContainer = debugContainer;
			GlobalUIContext.vectorUIContainer = topcontainer;
			GlobalUIContext.vectorStage = stage;
			
			driver = new TextField();
			GlobalUIContext.vectorUIContainer.addChild(driver);
		}
		
		private function onContextCreated(event:Event):void
		{
			
			
			driver.text = Starling.context.driverInfo.toLowerCase();
			driver.textColor = 0xFFFFFF;
			driver.autoSize = TextFieldAutoSize.LEFT;
			driver.x = stage.stageWidth - driver.textWidth - 2;
			// set framerate to 30 in software mode
			
		
		}
	}
}