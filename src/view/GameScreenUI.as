package view 
{
	import feathers.controls.Button;
	import flash.geom.Point;
	import model.CellConstants;
	import model.GameModel;
	import model.TextureStore;
	import patterns.events.LazyModeratorEvent;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import ui.scoreboard.ScoreboardStarling;
	import view.components.AlignContainer;
	import view.components.ClockIcon;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameScreenUI extends Sprite 
	{
		[Inject]
		public var textureStore:TextureStore
		
		private var updateStrategy:Object;
		private var gameModel:GameModel;
		
		private var timerValue:ScoreboardStarling;
		private var minesOnFieldValue:ScoreboardStarling;
		private var openedFieldsValue:ScoreboardStarling;
		
		private var timerIcon:ClockIcon;
		private var mineIcon:Image;
		
		public var backButton:Button;
		public var fullScreen:Button;
		
		private var viewComponentPosition:Point = new Point(0, 0);
		private var uiPanel:AlignContainer;
		private var fieldIcon:Image;
		public var maxWidth:Number;
		
		public function GameScreenUI(gameModel:GameModel = null) 
		{
			inject(this);
			
			fullScreen = createButton('FULLSCREEN');
			backButton = createButton('BACK');
			
			super();
			this.gameModel = gameModel;
			
			initilize();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function deactivate():void
		{
			stage.removeEventListener(Event.RESIZE, align);
			gameModel.removeEventListener(LazyModeratorEvent.UPDATE_EVENT, updateView);
			
		}
		
		public function createButton(text:String):Button
		{
			var button:Button = new Button()
			button.label = text;
			
			button.width = 150;
			button.height = 42;
			
			return button;
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.addEventListener(Event.RESIZE, align);
			align();
		}
		
		public function setGameModel(gameModel:GameModel):void
		{
			if (gameModel)
			{
				gameModel.removeEventListener(LazyModeratorEvent.UPDATE_EVENT, updateView);
			}
				
			this.gameModel = gameModel;
				
			updateMinesCount();
			updateMineFields();
			
			
			align();
			
			gameModel.addEventListener(LazyModeratorEvent.UPDATE_EVENT, updateView);
		}
		
		private function initilize():void 
		{
			craeteUI();
			
			updateStrategy = { 'openedField':updateMineFields, 'foundedMines':updateMinesCount, 'gameTime':updateTimer }
			
			
			
		}
		
		private function updateTimer():void 
		{
			timerValue.scores = gameModel.gameTime;
			timerIcon.time = gameModel.gameTime
		}
		
		private function updateMinesCount():void 
		{
			minesOnFieldValue.value = gameModel.foundedMines+'/'+gameModel.minesCount;
		}
		
		private function updateMineFields():void 
		{
			openedFieldsValue.value = gameModel.openedField + '/' + gameModel.totalField;
		}
		
		private function craeteUI():void 
		{
			var isLand:Boolean = CellConstants.APPLICATION_HEIGHT > CellConstants.APPLICATION_WIDTH;
			var timer:AlignContainer = new AlignContainer(0, AlignContainer.BOTTOM);
			var minesCount:AlignContainer = new AlignContainer(0, AlignContainer.BOTTOM);
			var fieldContainer:AlignContainer = new AlignContainer(0, AlignContainer.BOTTOM);
			
			
			timerValue = new ScoreboardStarling();
			minesOnFieldValue = new ScoreboardStarling();
			openedFieldsValue = new ScoreboardStarling();
			
			
			mineIcon = new Image(textureStore.getTexture('gnomemines'));
			timerIcon = new ClockIcon(textureStore.getTexture('gnomepanelclock'), textureStore.getTexture('clockArrow'));
			fieldIcon = new Image(textureStore.getTexture('cell_normal'));
			
			mineIcon.scaleX = mineIcon.scaleY = 64/85;
			fieldIcon.scaleX = fieldIcon.scaleY = 64/85;
			//timerIcon.scaleX = timerIcon.scaleY = 0.5;
			
			
			timer.addElements(timerIcon, timerValue);
			minesCount.addElements(mineIcon, minesOnFieldValue);
			fieldContainer.addElements(fieldIcon, openedFieldsValue);
			
			uiPanel = new AlignContainer(0, isLand ? AlignContainer.RIGHT:AlignContainer.BOTTOM);
			
			uiPanel.addElements(timer, minesCount, fieldContainer);
			
			addChild(uiPanel);
			addChild(fullScreen);
			addChild(backButton);
		}
		
		
		private function updateView(e:LazyModeratorEvent):void 
		{
			
			var fieldName:String = '';
			var fields:Object = gameModel.getFieldsList();
			
			for (fieldName in fields)
				if(updateStrategy.hasOwnProperty(fieldName))
					updateStrategy[fieldName]();
					
			uiPanel.flatten();
		}
		
		private function aligneToIconY(icon:DisplayObject, alignElement:DisplayObject):void
		{
			//alignElement.x = icon.x + icon.width;
			alignElement.y = icon.y + (icon.height - alignElement.height) / 2;
		}
		
		private function aligneToX(icon:DisplayObject, alignElement:DisplayObject):void
		{
			alignElement.x = icon.x + (icon.width - alignElement.width) / 2;
			//alignElement.y = icon.y + (icon.height - alignElement.height) / 2;
		}
		
		private function align(e:* = null):void 
		{
			
			//timerValue.x = 40 - (timerValue.width - timerValue.getTextBoudns().x);
			
			if(!stage)
				return;
			
			fullScreen.x = 5;
			fullScreen.y = stage.stageHeight - 5 - fullScreen.height;
			
			backButton.x = 5;
			backButton.y = fullScreen.y - backButton.height - 5;
			
			maxWidth = backButton.x + backButton.width + 5;
			
			trace(Math.max(timerIcon.width, timerValue.getTextBoudns().width));
			
			uiPanel.y = 10;
			
			if (CellConstants.APPLICATION_HEIGHT > CellConstants.APPLICATION_WIDTH)
			{
				//uiPanel.x = (CellConstants.APPLICATION_WIDTH - uiPanel.width) / 2;
				
				//aligneToIconY(timerIcon, timerValue);
				//aligneToIconY(mineIcon, minesOnFieldValue);
				//minesOnFieldValue.align();
				//timerValue.align();
				
				aligneToX(timerValue, timerIcon);
				aligneToX(minesOnFieldValue, mineIcon);
				aligneToX(openedFieldsValue, fieldIcon);
				
			}
			else
			{
				aligneToX(timerIcon, timerValue);
				aligneToX(mineIcon, minesOnFieldValue);
				aligneToX(minesOnFieldValue, openedFieldsValue);
				
				//timerValue.align();
				
				//uiPanel.x = (maxWidth - Math.max(timerIcon.width, timerValue.getTextBoudns().width)) / 2;
				uiPanel.x = (maxWidth - timerIcon.width) / 2;
			}
		}
	}

}