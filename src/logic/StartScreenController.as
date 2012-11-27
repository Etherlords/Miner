package logic 
{
	import core.scene.AbstractSceneController;
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import model.SettingsModel;
	import particles.boomParticle.BoomParticle;
	import particles.curosrParticle.CursorParticle;
	import particles.starParticles.StarParticlesEmmiter;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import utils.GlobalUIContext;
	import view.StartScreenView;
	
	/**
	 * ...
	 * @author 
	 */
	public class StartScreenController extends AbstractSceneController 
	{
		private var viewInstance:StartScreenView;
		private var cursorParticle:CursorParticle;
		
		private var gameModes:Array = 
										[
											{
												lable:'GAME FIELD 9x9 MINES COUNT 10', size:9, mines:10
											}
											,
											{
												lable:'GAME FIELD 16x16 MINES COUNT 40', size:16, mines:40
											}
											,
											{
												lable:'GAME FIELD 22x22 MINES COUNT 90', size:22, mines:90
											}
											,
											{
												lable:'GAME FIELD 30x30 MINES COUNT 150', size:30, mines:150
											}
											,
											{
												lable:'GAME FIELD 35x35 MINES COUNT 200', size:35, mines:200
											}
											,
											{
												lable:'GAME FIELD 40x40 MINES COUNT 280', size:40, mines:280
											}
											,
											{
												lable:'GAME FIELD 50x50 MINES COUNT 400', size:50, mines:400
											}
										]
										
		private var currentMode:int = 0;
		
		public function StartScreenController() 
		{
			super();
		}
		
		private function postInitilize():void 
		{
			cursorParticle = new CursorParticle();
			
			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.data = new <BitmapData>[new BitmapData(1, 1, true, 0x01000000)];
			Mouse.registerCursor('noneCursor', cursorData);
			Mouse.cursor = 'noneCursor';
			
			var stars:StarParticlesEmmiter = new StarParticlesEmmiter();
			stars.maxNumParticles = 100;
			stars.startColor.alpha = 0.4;
			
			viewInstance.addChild(stars);
			
			stars.y = -10;
			
			this.viewInstance.stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			viewInstance.addChild(cursorParticle);
			
			cursorParticle.emitterX = GlobalUIContext.vectorStage.mouseX;
			cursorParticle.emitterY = GlobalUIContext.vectorStage.mouseY;
			
			viewInstance.startGameButton.addEventListener(Event.TRIGGERED, startGame);
			viewInstance.left.addEventListener(Event.TRIGGERED, changeGameModeLeft);
			viewInstance.right.addEventListener(Event.TRIGGERED, changeGameModeRight);
		}
		
		private function changeGameModeRight(e:Event):void 
		{
			currentMode++
			if (currentMode == gameModes.length)
				currentMode = 0;
				
			chageMode();
		}
		
		private function chageMode():void 
		{
			viewInstance.fieldSize.text = gameModes[currentMode].lable;
		}
		
		private function changeGameModeLeft(e:Event):void 
		{
			currentMode--
			
			if (currentMode < 0)
				currentMode = gameModes.length-1;
				
			chageMode();
		}
		
		private function startGame(e:Event):void 
		{
			SettingsModel.instance.fieldHeight = gameModes[currentMode].size
			SettingsModel.instance.fieldWidth = gameModes[currentMode].size
			SettingsModel.instance.minesCount = gameModes[currentMode].mines
			trace(SettingsModel.instance.fieldHeight, SettingsModel.instance.fieldWidth, SettingsModel.instance.minesCount);
			
			super.exit();
		}
		
		private function onTouch(e:TouchEvent):void 
		{
		
				cursorParticle.emitterX = e.touches[0].globalX
				cursorParticle.emitterY = e.touches[0].globalY
			
		}
		
		override protected function initilize():void 
		{
			
			
			super.initilize();
		}
		
		override public function activate(instance:DisplayObjectContainer):void 
		{
			viewInstance = new StartScreenView();
			setViewComponent(viewInstance);
			
			super.activate(instance);
			
			postInitilize();
		}
		
		
		
	}

}