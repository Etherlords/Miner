package logic
{
	import core.scene.AbstractSceneController;
	import flash.display.StageDisplayState;
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
	import particles.boomParticle.BoomParticle;
	import particles.curosrParticle.CursorParticle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.filters.BlurFilter;
	import utils.GlobalUIContext;
	import view.components.Alert;
	import view.MainGaimView;
	
	
	
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
		private var _actualTime:Date;
		
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
			
			
			viewInstance.removeChild(endGameAlert)
			
				
			super.deactivate();
			
		}
		
		private function setField():void
		{
			mineField.fieldWidth = SettingsModel.instance.fieldWidth;
			mineField.fieldHeight = SettingsModel.instance.fieldHeight;
			
			var lowestSide:Number = Math.min(CellConstants.APPLICATION_HEIGHT, CellConstants.APPLICATION_WIDTH);
			var largestFieldSide:Number = mineField.fieldWidth > mineField.fieldHeight? mineField.fieldWidth:mineField.fieldHeight
			CellConstants.MINE_FIELD_GABARITE = Math.ceil(lowestSide / largestFieldSide );
			trace('CellConstants.MINE_FIELD_GABARITE', CellConstants.MINE_FIELD_GABARITE);
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
			viewInstance.fullScreen.addEventListener(Event.TRIGGERED, onFullScreen);
			viewInstance.backButton.addEventListener(Event.TRIGGERED, backToStartScreen);
			
			
			
			
			gameBuilder = new MineFieldBuilder();
			
			
			reset();
			
			viewInstance.initilize(mineField, gameModel);
			
			
			viewInstance.addEventListener('MineCellClicked', mineFieldClicked);
			viewInstance.addEventListener('MineCellRightClicked', flagCell);
			viewInstance.stage.addEventListener(TouchEvent.TOUCH, trachMouse);
			
			//viewInstance.stage.addChild(cursorParticle);
			
		}
		
		private function backToStartScreen(e:Event):void 
		{
			exit();
		}
		
		private function trachMouse(e:TouchEvent):void 
		{
			mouse = new Point(e.touches[0].globalX, e.touches[0].globalY);
			cursorParticle.emitterX = e.touches[0].globalX
			cursorParticle.emitterY = e.touches[0].globalY
		}
		
		private function onFullScreen(e:Event):void 
		{
			
			if(GlobalUIContext.vectorStage.displayState == StageDisplayState.NORMAL)
				GlobalUIContext.vectorStage.displayState = StageDisplayState.FULL_SCREEN
			else
				GlobalUIContext.vectorStage.displayState = StageDisplayState.NORMAL
		}
		 
		override protected function initilize():void
		{

			endGameAlert = new Alert()
			
			endGameAlert.addEventListener('restart', reset);
			
			
			
			mineField = new MineFieldModel();
			gameModel = new GameModel();
			
			gameTimer = new Timer(20);
			
			gameTimer.addEventListener(TimerEvent.TIMER, onSecondDelay);
		
			super.initilize();
		}
		
		private function reset(e:* = null):void 
		{
			gameModel.gameStatus = 0;
			gameBuilder.makeMineField(mineField, gameModel);
			
		
			viewInstance.removeChild(endGameAlert)
				
			gameTimer.start();
			_actualTime = new Date();
			
			
			if (viewInstance)
			{
				viewInstance.addEventListener('MineCellClicked', mineFieldClicked);
				viewInstance.addEventListener('MineCellRightClicked', flagCell);
				viewInstance.reset();
			}
			
		}
		
		private function onSecondDelay(e:TimerEvent):void 
		{
			var bufTime:Date = new Date();
			var timeDelta:Number = bufTime.getTime() - _actualTime.getTime()
			gameModel.gameTime += timeDelta/1000;
			_actualTime = bufTime;
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
			
			gameModel.gameStatus = isShowBlow? -1:1;
			
			var blow:BoomParticle = new BoomParticle();
			blow.x = mouse.x;
			blow.y = mouse.y;
			viewInstance.addChild(blow);
			blow.addEventListener(Event.COMPLETE, onBlowEnded);
			endGameAlert.text = Alerts.getEndGameText(gameModel.gameTime, gameModel.foundedMines, SettingsModel.instance.fieldWidth, gameModel.gameStatus > 0);
			gameTimer.stop();
			
			viewInstance.removeEventListener('MineCellClicked', mineFieldClicked);
			viewInstance.removeEventListener('MineCellRightClicked', flagCell);
			
			if (!isShowBlow)
			{
				blow.x = -1000;
			}
			else
			{
				shakeTween(view);
			}
			
			showAllMines();
			
		}
		
		private function shakeTween( item:DisplayObject ):void 
		{
			item.filter = new BlurFilter(0, 0);
			
			var blurTween:Tween = new Tween(item.filter, 0.1);
			blurTween.animate('blurX', item.y + (1 + Math.random() * 2));
			blurTween.animate('blurY', item.y + (1 + Math.random() * 2));
			blurTween.repeatCount = 6;
			
			var shake:Tween = new Tween(item, 0.1, Transitions.EASE_IN_BOUNCE);
			shake.animate('y', item.y + (1 + Math.random() * 2));
			shake.animate('x', item.x + (1 + Math.random() * 2));
			shake.delay = 0;
			shake.repeatCount = 6;
			
			var shake2:Tween = new Tween(item, 0.1);
			shake2.animate('y', item.y+(Math.random()*0));
			shake2.animate('x', item.x + (Math.random() * 0));
			shake.delay = 0.05;
			shake.repeatCount = 8;
			shake.onComplete = Delegate.create(onFinishTween, item);
			
			GlobalUIContext.starlingInstance.juggler.add(shake);
			GlobalUIContext.starlingInstance.juggler.add(shake2);
			GlobalUIContext.starlingInstance.juggler.add(blurTween);
			
		   function onFinishTween(item:DisplayObject):void
		   {
			  
				var blurTweenOut:Tween = new Tween(item.filter, 0.1);
				blurTweenOut.animate('blurX', 0);
				blurTweenOut.animate('blurY', 0);
				
			   GlobalUIContext.starlingInstance.juggler.add(blurTweenOut);
			
			   item.x = 0;
			   item.y = 0;
		   }

		}
		
		private function onBlowEnded(e:Event):void 
		{
			viewInstance.removeChild(e.target as Sprite);
			e.target.removeEventListener(Event.COMPLETE, onBlowEnded);
			
			
			//endGameAlert.x = (GlobalUIContext.vectorStage.stageWidth - endGameAlert.width) / 2;
			//endGameAlert.y = (GlobalUIContext.vectorStage.stageHeight - endGameAlert.height) / 2;
			viewInstance.addChild(endGameAlert)
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