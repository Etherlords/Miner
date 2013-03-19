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
	
	/**
	 * ...
	 * @author 
	 */
	public class GameScreenUI extends Sprite 
	{
		private var updateStrategy:Object;
		private var gameModel:GameModel;
		
		private var timerValue:ScoreboardStarling;
		private var minesOnFieldValue:ScoreboardStarling;
		private var openedFieldsValue:ScoreboardStarling;
		private var tottalFieldsValue:ScoreboardStarling;
		
		private var timerIcon:Image;
		private var mineIcon:Image;
		
		public var backButton:Button;
		public var fullScreen:Button;
		
		private var viewComponentPosition:Point = new Point(0, 0);
		private var uiPanel:AlignContainer;
		
		public function GameScreenUI(gameModel:GameModel = null) 
		{
			fullScreen = createButton('large_button_normal', 'large_button_down', 'Toggle full screen', 'Desyrel', -1, 0xFFFFFF, true);
			backButton = createButton('large_button_normal', 'large_button_down', 'Back to menu', 'Desyrel', -1, 0xFFFFFF, true);
			
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
			var button:Button = new Button(TextureStore.texturesAtlas.getTexture(textureNormal), text, TextureStore.texturesAtlas.getTexture(textureDown))
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
			var timer:AlignContainer = new AlignContainer(AlignContainer.BOTTOM);
			var minesCount:AlignContainer = new AlignContainer(AlignContainer.BOTTOM);
			
			timerValue = new ScoreboardStarling();
			minesOnFieldValue = new ScoreboardStarling();
			openedFieldsValue = new ScoreboardStarling();
			tottalFieldsValue = new ScoreboardStarling();
			
			mineIcon = new Image(TextureStore.texturesAtlas.getTexture('gnomemines'));
			timerIcon = new Image(TextureStore.texturesAtlas.getTexture('gnomepanelclock'));
			
			mineIcon.scaleX = mineIcon.scaleY = 0.5;
			timerIcon.scaleX = timerIcon.scaleY = 0.5;
			
			
			timer.addElements(timerIcon, timerValue);
			minesCount.addElements(mineIcon, minesOnFieldValue);
			
			uiPanel = new AlignContainer(CellConstants.APPLICATION_HEIGHT > CellConstants.APPLICATION_WIDTH? AlignContainer.RIGHT:AlignContainer.BOTTOM, 10);
			
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
				
			align();
			
			uiPanel.flatten();
		}
		
		private function aligneToIcon(icon:DisplayObject, alignElement:DisplayObject):void
		{
			alignElement.x = icon.x + icon.width;
			alignElement.y = icon.y + (icon.height - alignElement.height) / 4;
		}
		
		private function align(e:* = null):void 
		{
			
			if(!stage)
				return;
			
			fullScreen.x = 10;
			fullScreen.y = stage.stageHeight - 10 - fullScreen.height;
			
			backButton.x = 10;
			backButton.y = fullScreen.y - backButton.height - 10;
			
			
		}
	}

}