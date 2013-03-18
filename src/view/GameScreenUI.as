package view 
{
	import flash.geom.Point;
	import model.GameModel;
	import model.TextureStore;
	import patterns.events.LazyModeratorEvent;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import ui.scoreboard.ScoreboardStarling;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameScreenUI extends Sprite 
	{
		
		
		private var timer:ScoreboardStarling;
		private var minesOnField:ScoreboardStarling;
		private var gameModel:GameModel;
		private var updateStrategy:Object;
		private var openedFields:ScoreboardStarling;
		private var tottalFields:ScoreboardStarling;
		
		private var viewComponentPosition:Point = new Point(0, 0);
		private var clockImage:Image;
		private var mineImage:Image;
		public var backButton:Button;
		
		public var fullScreen:Button;
		
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
			timer.scores = gameModel.gameTime;
		}
		
		private function updateMinesCount():void 
		{
			minesOnField.scores = gameModel.minesCount - gameModel.foundedMines;
		}
		
		private function updateMineFields():void 
		{
			openedFields.scores = gameModel.openedField;
			tottalFields.scores = gameModel.totalField;
		}
		
		private function craeteUI():void 
		{
			timer = new ScoreboardStarling();
			minesOnField = new ScoreboardStarling();
			openedFields = new ScoreboardStarling();
			tottalFields = new ScoreboardStarling();
			
			mineImage = new Image(TextureStore.texturesAtlas.getTexture('gnomemines'));
			clockImage = new Image(TextureStore.texturesAtlas.getTexture('gnomepanelclock'));
			
			mineImage.scaleX = mineImage.scaleY = 0.5;
			clockImage.scaleX = clockImage.scaleY = 0.5;
			
			addChild(timer);
			addChild(minesOnField);
			addChild(openedFields);
			addChild(tottalFields);
			
			addChild(mineImage);
			addChild(clockImage);
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
		}
		
		private function aligneToIcon(icon:DisplayObject, alignElement:DisplayObject):void
		{
			alignElement.x = icon.x + icon.width;
			alignElement.y = icon.y + (icon.height - alignElement.height) / 4;
		}
		
		private function align(e:* = null):void 
		{

				
			viewComponentPosition.x = 10;
			viewComponentPosition.y = 10;
			
			clockImage.x = viewComponentPosition.x;
			clockImage.y = viewComponentPosition.y;
			
			aligneToIcon(clockImage, timer);
			
			viewComponentPosition.y = clockImage.y + clockImage.height + 10;
			
			mineImage.x = viewComponentPosition.x;
			mineImage.y = viewComponentPosition.y;
			
			aligneToIcon(mineImage, minesOnField);
			
			
			viewComponentPosition.y = mineImage.y + mineImage.height + 10;
			
			openedFields.x = viewComponentPosition.x;
			openedFields.y = viewComponentPosition.y;
			
			viewComponentPosition.y = openedFields.y + openedFields.height + 10;
			
			tottalFields.x = viewComponentPosition.x;
			tottalFields.y = viewComponentPosition.y;
			
			if(!stage)
				return;
			
			fullScreen.x = 10;
			fullScreen.y = stage.stageHeight - 10 - fullScreen.height;
			
			backButton.x = 10;
			backButton.y = fullScreen.y - backButton.height - 10;
			
			
		}
	}

}