package view 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import model.GameModel;
	import patterns.events.LazyModeratorEvent;
	import ui.scoreboard.Scoreboard;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameScreenUI extends Sprite 
	{
		
		[Embed(source = "../../lib/gnomemines.png")]
		private var mineSource:Class;
		private var mineImage:Bitmap = new mineSource();
		
		[Embed(source = "../../lib/gnomepanelclock.png")]
		private var clockSource:Class;
		private var clockImage:Bitmap = new clockSource();
		
		private var timer:Scoreboard;
		private var minesOnField:Scoreboard;
		private var gameModel:GameModel;
		private var updateStrategy:Object;
		private var openedFields:Scoreboard;
		private var tottalFields:Scoreboard;
		
		private var viewComponentPosition:Point = new Point(0, 0);
		
		public function GameScreenUI(gameModel:GameModel = null) 
		{
			super();
			this.gameModel = gameModel;
			
			initilize();
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
			
			
			align();
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
			timer = new Scoreboard();
			minesOnField = new Scoreboard();
			openedFields = new Scoreboard();
			tottalFields = new Scoreboard();
			
			mineImage.scaleX = mineImage.scaleY = 0.5;
			clockImage.scaleX = clockImage.scaleY = 0.5;
			
			addChild(timer);
			addChild(minesOnField);
			addChild(openedFields);
			addChild(tottalFields);
			
			addChild(mineImage);
			addChild(clockImage);
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
		
		private function align():void 
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
			
			
			
			
			
		}
	}

}