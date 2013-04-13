package view 
{
	import flash.geom.Point;
	import model.CellConstants;
	import model.GameModel;
	import model.TextureStore;
	import patterns.events.LazyModeratorEvent;
	import starling.display.Button;
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
		private var tottalFieldsValue:ScoreboardStarling;
		
		private var timerIcon:ClockIcon;
		private var mineIcon:Image;
		
		public var backButton:Button;
		public var fullScreen:Button;
		
		private var viewComponentPosition:Point = new Point(0, 0);
		private var uiPanel:AlignContainer;
		public var maxWidth:Number;
		
		public function GameScreenUI(gameModel:GameModel = null) 
		{
			inject(this);
			
			fullScreen = createButton('big_button_normal', 'big_button_down', 'Toggle full screen', 'a_LCDNova', -1, 0xAAA7A5, true);
			backButton = createButton('big_button_normal', 'big_button_down', 'Back to menu', 'a_LCDNova', -1, 0xAAA7A5, true);
			
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
		
		public function createButton(textureNormal:String, textureDown:String, text:String, fontName:String, size:int = -1, color:uint = 0x0, bold:Boolean =false ):Button
		{
			var button:Button = new Button(textureStore.getTexture(textureNormal), text, textureStore.getTexture(textureDown))
			button.fontName = fontName;
			button.fontBold = bold;
			button.fontSize = size;
			button.fontColor = color;
			
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
			minesOnFieldValue.scores = gameModel.minesCount - gameModel.foundedMines;
		}
		
		private function updateMineFields():void 
		{
			openedFieldsValue.scores = gameModel.openedField;
			tottalFieldsValue.scores = gameModel.totalField;
		}
		
		private function craeteUI():void 
		{
			var timer:AlignContainer = new AlignContainer(0, AlignContainer.BOTTOM);
			var minesCount:AlignContainer = new AlignContainer(0, AlignContainer.BOTTOM);
			
			timerValue = new ScoreboardStarling();
			minesOnFieldValue = new ScoreboardStarling();
			openedFieldsValue = new ScoreboardStarling();
			tottalFieldsValue = new ScoreboardStarling();
			
			mineIcon = new Image(textureStore.getTexture('gnomemines'));
			timerIcon = new ClockIcon(textureStore.getTexture('gnomepanelclock'), textureStore.getTexture('clockArrow'));
			
			mineIcon.scaleX = mineIcon.scaleY = 64/85;
			//timerIcon.scaleX = timerIcon.scaleY = 0.5;
			
			
			timer.addElements(timerIcon, timerValue);
			minesCount.addElements(mineIcon, minesOnFieldValue);
			
			uiPanel = new AlignContainer(0, CellConstants.APPLICATION_HEIGHT > CellConstants.APPLICATION_WIDTH? AlignContainer.RIGHT:AlignContainer.BOTTOM);
			
			uiPanel.addElements(timer, minesCount, openedFieldsValue, tottalFieldsValue);
			
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
			uiPanel.x = uiPanel.y = 10;
			
			if (CellConstants.APPLICATION_HEIGHT > CellConstants.APPLICATION_WIDTH)
			{
				aligneToIconY(timerIcon, timerValue);
				aligneToIconY(mineIcon, minesOnFieldValue);
				minesOnFieldValue.align();
				timerValue.align();
			}
			else
			{
				aligneToX(timerIcon, timerValue);
				aligneToX(mineIcon, minesOnFieldValue);
				aligneToX(minesOnFieldValue, openedFieldsValue);
				aligneToX(minesOnFieldValue, tottalFieldsValue);
				//timerValue.align();
			}
			//timerValue.x = 40 - (timerValue.width - timerValue.getTextBoudns().x);
			
			if(!stage)
				return;
			
			fullScreen.x = 5;
			fullScreen.y = stage.stageHeight - 5 - fullScreen.height;
			
			backButton.x = 5;
			backButton.y = fullScreen.y - backButton.height - 5;
			
			maxWidth = backButton.x + backButton.width;
		}
	}

}