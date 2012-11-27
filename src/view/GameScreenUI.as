package view 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import model.GameModel;
	import model.TextureStore;
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
		public var fullScreen:SimpleButton;
		
		public function GameScreenUI(gameModel:GameModel = null) 
		{
			var texture:BitmapData = TextureStore.button2Image.clone();
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat('Ubuntu', 15, 0x0, true);
			tf.embedFonts = true;
			tf.text = 'TOGGLE FULL SCREEN';
			var m:Matrix = new Matrix();
			m.tx = 15
			m.ty = 10
			texture.draw(tf, m);
			var buttonDisplay:Bitmap = new Bitmap(texture);
			
			
			
			fullScreen = new SimpleButton(buttonDisplay, buttonDisplay, buttonDisplay, buttonDisplay);
			
			
			
			super();
			this.gameModel = gameModel;
			
			initilize();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
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
			addChild(fullScreen);
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
			
			fullScreen.x = 10;
			fullScreen.y = stage.stageHeight - 10 - fullScreen.height;
			
			
			
		}
	}

}