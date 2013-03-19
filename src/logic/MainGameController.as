package logic
{
	import core.scene.AbstractSceneController;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import logic.MineFieldBuilder;
	import model.Alerts;
	import model.CellConstants;
	import model.GameModel;
	import model.MineFieldCellModel;
	import model.MineFieldModel;
	import model.SettingsModel;
	import model.TextureStore;
	import particles.boomParticle.BoomParticle;
	import particles.curosrParticle.CursorParticle;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import ui.Alert;
	import utils.GlobalUIContext;
	import view.MainGaimView;
	import view.MineFieldCellView;
	
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class MainGameController extends AbstractSceneController
	{
		private var viewInstance:MainGaimView;
		private var mineField:MineFieldModel;
		private var gameModel:GameModel;
		private var gameBuilder:MineFieldBuilder;
		private var endGameAlert:Alert;
		private var gameTimer:Timer;
		private var mouse:Point;
		private var cursorParticle:CursorParticle;
		
		public function MainGameController()
		{
		
		}
		
		override public function deactivate():void 
		{
			if (!isActivated)
				return;
			
			/*viewInstance.fullScreen.removeEventListener(TouchEvent.TOUCH, onFullScreen);
			viewInstance.backButton.removeEventListener(TouchEvent.TOUCH, backToStartScreen);
			viewInstance.removeEventListener('MineCellClicked', mineFieldClicked);
			viewInstance.removeEventListener('MineCellRightClicked', flagCell);
			viewInstance.stage.removeEventListener(TouchEvent.TOUCH, trachMouse);
			endGameAlert.removeEventListener('restart', reset);
			gameTimer.removeEventListener(TimerEvent.TIMER, onSecondDelay);
			viewInstance.removeEventListener('MineCellClicked', mineFieldClicked);
			viewInstance.removeEventListener('MineCellRightClicked', flagCell);
				*/
			gameTimer.stop();
			viewInstance.deactivate()
			
				
			super.deactivate();
			
		}
		
		private function setField():void
		{
			mineField.fieldWidth = SettingsModel.instance.fieldWidth;
			mineField.fieldHeight = SettingsModel.instance.fieldHeight;
			
			var lowestSide:Number = Math.min(CellConstants.APPLICATION_HEIGHT, CellConstants.APPLICATION_WIDTH);
			var largestFieldSide:Number = mineField.fieldWidth > mineField.fieldHeight? mineField.fieldWidth:mineField.fieldHeight
			CellConstants.MINE_FIELD_GABARITE = lowestSide / largestFieldSide;

			//CellConstants.MINE_FIELD_GABARITE *= 8.5 / largestFieldSide;
			
			gameModel.minesCount = SettingsModel.instance.minesCount;
			gameModel.totalField = mineField.fieldWidth * mineField.fieldHeight;
		}
		
		public override function activate(instance:DisplayObjectContainer):void
		{
			if (isActivated)
				return;
				
			setField();
			
			var initilize:Boolean = !viewInstance
			
			if (initilize)
			{
				viewInstance = new MainGaimView();
				
			
			}
			
			setViewComponent(viewInstance);
			
			super.activate(instance);
			
			if (initilize)
				postInitilize();
			else
				reset();
		}
		
		private function flagCell(e:Event):void 
		{
		
			if (e.data.j >= mineField.fieldHeight || e.data.i >= mineField.fieldWidth)
				return
			
			var cellModel:MineFieldCellModel = mineField.viewField[e.data.i][e.data.j];
			
			if (cellModel.viewState == CellConstants.OPEN_STATE)
				return;
			
			cellModel.isFlagged = !cellModel.isFlagged
			
			if (cellModel.isFlagged)
				gameModel.foundedMines++;
			else
				gameModel.foundedMines--;
			
			cellModel.update();
		
		}
		
		private function mineFieldClicked(e:Event):void 
		{
			calcOpenSpace(e.data.i, e.data.j);
			
		}
		
		private function postInitilize():void 
		{
			
			cursorParticle = new CursorParticle();
			
			cursorParticle.emitterX = GlobalUIContext.vectorStage.mouseX;
			cursorParticle.emitterY = GlobalUIContext.vectorStage.mouseY;
			
			
			
			
			trace('viewInstance.fullScreen');
			viewInstance.fullScreen.addEventListener(TouchEvent.TOUCH, onFullScreen);
			viewInstance.backButton.addEventListener(TouchEvent.TOUCH, backToStartScreen);
			
			
			
			
			gameBuilder = new MineFieldBuilder();
			
			
			reset();
			
			viewInstance.initilize(mineField, gameModel);
			
			
			viewInstance.addEventListener('MineCellClicked', mineFieldClicked);
			viewInstance.addEventListener('MineCellRightClicked', flagCell);
			viewInstance.stage.addEventListener(TouchEvent.TOUCH, trachMouse);
			
			//viewInstance.stage.addChild(cursorParticle);
			
		}
		
		private function backToStartScreen(e:TouchEvent):void 
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				trace('exit');
				exit();
			}
		}
		
		private function trachMouse(e:TouchEvent):void 
		{
			mouse = new Point(e.touches[0].globalX, e.touches[0].globalY);
			cursorParticle.emitterX = e.touches[0].globalX
			cursorParticle.emitterY = e.touches[0].globalY
		}
		
		private function onFullScreen(e:TouchEvent):void 
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				trace('click');
				if(GlobalUIContext.vectorStage.displayState == StageDisplayState.NORMAL)
					GlobalUIContext.vectorStage.displayState = StageDisplayState.FULL_SCREEN
				else
					GlobalUIContext.vectorStage.displayState = StageDisplayState.NORMAL
			}
		}
		 
		override protected function initilize():void
		{

			endGameAlert = new Alert(Alerts.START_SCREEN)
			
			endGameAlert.addEventListener('restart', reset);
			
			endGameAlert.x = (GlobalUIContext.vectorStage.stageWidth - endGameAlert.width) / 2;
			endGameAlert.y = (GlobalUIContext.vectorStage.stageHeight - endGameAlert.height) / 2;
			
			mineField = new MineFieldModel();
			gameModel = new GameModel();
			
			gameTimer = new Timer(1000);
			
			gameTimer.addEventListener(TimerEvent.TIMER, onSecondDelay);
			
			var textures:TextureStore = new TextureStore();
			
			
			super.initilize();
		}
		
		private function reset(e:* = null):void 
		{
			trace('restart game');
			gameBuilder.makeMineField(mineField, gameModel);
			
			if(GlobalUIContext.vectorUIContainer.contains(endGameAlert))
				GlobalUIContext.vectorUIContainer.removeChild(endGameAlert)
				
			gameTimer.start();
			
			
			
			if (viewInstance)
			{
				viewInstance.addEventListener('MineCellClicked', mineFieldClicked);
				viewInstance.addEventListener('MineCellRightClicked', flagCell);
				viewInstance.reset();
			}
			
		}
		
		private function onSecondDelay(e:TimerEvent):void 
		{
			gameModel.gameTime++;
		}
		
		public function calcOpenSpace(i:int, j:int):void
		{
			var fieldModel:MineFieldCellModel = mineField.viewField[i][j];
			
			if (fieldModel.isFlagged)
				return;
				
			if (fieldModel.fieldStatus == -1)
				mineFinded(i, j);
				
			var openSpace:Array = [];
			var objectsPull:Dictionary = new Dictionary;
			foundOpenNeighbors(i, j, objectsPull)
			
			for each (var obj:MineFieldCellModel in objectsPull)
			{
				obj.viewState = CellConstants.OPEN_STATE;
				obj.update();
				
				gameModel.openedField++;
				
			}
			
			if (gameModel.openedField == gameModel.totalField - gameModel.minesCount)
			{
				trace('game end');
				gameOver(false);
			}
		
		}
		
		private function showAllMines():void
		{
			var jindex:int;
			var index:int;
			for (index = 0; index < mineField.fieldWidth; index++)
				{
					for (jindex = 0; jindex < mineField.fieldHeight; jindex++)
					{
						
						if (mineField.viewField[index][jindex].fieldStatus == -1)
						{
							mineField.viewField[index][jindex].viewState = CellConstants.MINE_FINDED_STATE
							mineField.viewField[index][jindex].update();
							
						}
					}
				}
		}
		
		private function gameOver(isShowBlow:Boolean):void
		{
			var blow:BoomParticle = new BoomParticle();
			blow.x = mouse.x;
			blow.y = mouse.y;
			viewInstance.addChild(blow);
			blow.addEventListener(Event.COMPLETE, onBlowEnded);
			gameTimer.stop();
			
			viewInstance.removeEventListener('MineCellClicked', mineFieldClicked);
			viewInstance.removeEventListener('MineCellRightClicked', flagCell);
			
			if (!isShowBlow)
				blow.x = -1000;
			
			showAllMines();
			
		}
		
		private function onBlowEnded(e:Event):void 
		{
			viewInstance.removeChild(e.target as Sprite);
			e.target.removeEventListener(Event.COMPLETE, onBlowEnded);
			
			GlobalUIContext.vectorUIContainer.addChild(endGameAlert)
		}
		
		private function foundOpenNeighbors(i:int, j:int, openSpace:Dictionary):void
		{
			var limitFlag:Boolean = false;
			
			if (mineField.viewField[i][j].isFlagged)
				return
			else if (mineField.actualField[i][j] == -1)
			{
				
				return;
			}
			else
			{
				if (mineField.viewField[i][j].viewState == CellConstants.OPEN_STATE)
					return;
				
				if (openSpace[mineField.viewField[i][j]])
					return;
				
				openSpace[mineField.viewField[i][j]] = mineField.viewField[i][j];
			}
			
			limitFlag = mineField.actualField[i][j] > 0;
			
			if (limitFlag)
				return;
			
			if (j != 0)
				foundOpenNeighbors(i, j - 1, openSpace);
			
			if (i != 0)
				foundOpenNeighbors(i - 1, j, openSpace);
			
			if (j != mineField.fieldWidth - 1)
				foundOpenNeighbors(i, j + 1, openSpace);
			
			if (i != mineField.fieldHeight - 1)
				foundOpenNeighbors(i + 1, j, openSpace);
		
		
			if (i != 0 && j != 0)
			{
				foundOpenNeighbors(i - 1, j - 1, openSpace );
			}

			if (i != mineField.fieldWidth - 1 && j != mineField.fieldWidth - 1)
			{
				foundOpenNeighbors(i + 1, j + 1, openSpace );
			}

			if (i != mineField.fieldWidth - 1 && j != 0)
			{
				foundOpenNeighbors(i + 1, j - 1, openSpace );
			}

			if (i != 0 && j != mineField.fieldWidth - 1)
			{
				foundOpenNeighbors(i - 1, j + 1, openSpace );
			}
		 
		}
		
		private function mineFinded(i:int, j:int):void 
		{
			mineField.viewField[i][j].viewState = CellConstants.MINE_FINDED_STATE
			mineField.viewField[i][j].update();
			gameOver(true);
			//reset();
		}
		
		
	
	}

}