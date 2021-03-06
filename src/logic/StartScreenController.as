package logic 
{
	import core.scene.AbstractSceneController;
	import core.ui.KeyBoardController;
	import flash.display.BitmapData;
	import starling.text.TextField;
	import flash.ui.Keyboard;
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
		private var cursors:Vector.<CursorParticle> = new Vector.<CursorParticle>
		
		private var fieldSizes:Array =	 [9, 	16, 	22, 	35, 	40,	 	50,		60,		70, 	80, 	90, 	100];
		private var defaultMines:Array = [10,	 40, 	90, 	180, 	250, 	420, 	612, 	880, 	1200, 	1620, 	2100];
		private var minesCount:int = 10;
		
		private var FIELD_SIZE_LABLE:String = 'FIELD SIZE $x$';
		private var MINES_COUNT_LABLE:String = 'MINES COUNT $';
										
		private var currentMode:int = 0;
		private var keyController:KeyBoardController;
		
		private var softcore:Boolean = true;
		
		public function StartScreenController() 
		{
			super();
		}
		
		private function postInitilize():void 
		{
			
			
			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.data = new <BitmapData>[new BitmapData(1, 1, true, 0x01000000)];
			Mouse.registerCursor('noneCursor', cursorData);
			//Mouse.cursor = 'noneCursor';
			
			var stars:StarParticlesEmmiter = new StarParticlesEmmiter();
			stars.maxNumParticles = 100;
			stars.startColor.alpha = 0.4;
			
			viewInstance.addChild(stars);
			
			craeteCursor(0, 0);
			
			stars.y = -10;
			
			this.viewInstance.stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			
			viewInstance.startGameButton.addEventListener(Event.TRIGGERED, startGame);
			viewInstance.left.addEventListener(Event.TRIGGERED, changeGameModeLeft);
			viewInstance.right.addEventListener(Event.TRIGGERED, changeGameModeRight);
			viewInstance.fieldSize.addEventListener(Event.TRIGGERED, changeGameModeRight);
			
			viewInstance.leftMines.addEventListener(Event.TRIGGERED, changeMinesLeft);
			viewInstance.rightMines.addEventListener(Event.TRIGGERED, changeMinesRight);
			viewInstance.minesCount.addEventListener(Event.TRIGGERED, changeMinesRight);
			
			viewInstance.difficle.addEventListener(Event.TRIGGERED, changeDifficle);
			viewInstance.difficleLable.addEventListener(Event.TRIGGERED, changeDifficle);
			
			keyController = new KeyBoardController(GlobalUIContext.vectorStage);
			
			
			
			
			chageMode();
		}
		
		private function changeDifficle(e:Event):void 
		{
			softcore = !softcore
			chageMode();
		}
		
		private function changeMinesRight(e:Event):void 
		{	
			if (keyController.isKeyDown(Keyboard.CONTROL))
				minesCount += 10;
			else
				minesCount++
				
			if (minesCount >= fieldSizes[currentMode] * fieldSizes[currentMode])
				minesCount = fieldSizes[currentMode] * fieldSizes[currentMode] - 1;
				
			chageMode();
		}
		
		private function changeMinesLeft(e:Event):void 
		{
			if (keyController.isKeyDown(Keyboard.CONTROL))
				minesCount -= 10;
			else
				minesCount--
				
			if (minesCount <= 0)
				minesCount = 1;
				
			chageMode();
		}
		
		private function changeGameModeRight(e:Event):void 
		{
			currentMode++
			if (currentMode == fieldSizes.length)
				currentMode = 0;
				
			minesCount = defaultMines[currentMode];
				
			chageMode();
		}
		
		private function chageMode():void 
		{
			viewInstance.fieldSize['label'] = FIELD_SIZE_LABLE.split('$').join(fieldSizes[currentMode]);
			viewInstance.minesCount['label'] = MINES_COUNT_LABLE.split('$').join(minesCount);
			viewInstance.difficleLable['label'] = softcore? 'SOFT':'HARD'
			viewInstance.difficle['label'] = 'DIFFICLE ' + (softcore? 'SOFT':'HARD');
		}
		
		private function changeGameModeLeft(e:Event):void 
		{
			currentMode--
			
			if (currentMode < 0)
				currentMode = fieldSizes.length-1;
			
			minesCount = defaultMines[currentMode];
				
			chageMode();
		}
		
		private function startGame(e:Event):void 
		{
			SettingsModel.instance.fieldHeight = fieldSizes[currentMode]
			SettingsModel.instance.fieldWidth = fieldSizes[currentMode]
			SettingsModel.instance.minesCount = minesCount
			trace(SettingsModel.instance.fieldHeight, SettingsModel.instance.fieldWidth, SettingsModel.instance.minesCount);
			
			super.exit();
		}
		
		private function craeteCursor(x:Number, y:Number):void
		{
			var cursorParticle:CursorParticle = new CursorParticle();
			
			viewInstance.addChild(cursorParticle);
			
			cursorParticle.emitterX = x;
			cursorParticle.emitterY = y;
			
			cursors.push(cursorParticle)
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			
			for (var i:int = 0; i < e.touches.length; i++)
			{
				if (cursors.length - 1 < i)
					craeteCursor(e.touches[i].globalX, e.touches[i].globalY);
					
				var cursorParticle:CursorParticle = cursors[i];
				
				cursorParticle.emitterX = e.touches[i].globalX
				cursorParticle.emitterY = e.touches[i].globalY
			}
			
		}
		
		override protected function initilize():void 
		{
			
			
			super.initilize();
		}
		
		override public function activate(instance:DisplayObjectContainer):void 
		{
			
			var initilzie:Boolean = !viewInstance;
			
			if(initilzie)
				viewInstance = new StartScreenView();
			
			setViewComponent(viewInstance);
			
			super.activate(instance);
			
			if(initilzie)
				postInitilize();
		}
		
		
		
	}

}