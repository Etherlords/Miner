package view 
{
	import logic.StartScreenController;
	import model.TextureStore;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import utils.GlobalUIContext;
	
	/**
	 * ...
	 * @author 
	 */
	public class StartScreenView extends Sprite 
	{
		static private const PADDING:Number = 5;
		public var minesCount:Button;
		public var rightMines:Button;
		public var leftMines:Button;
		public var startGameButton:Button;
		public var fieldSize:Button;
		public var left:Button;
		public var right:Button;
		
		private var buttonAssets:Array = [
											{
												normal:'large_button_normal', down:'large_button_down'
											}
											,
											{
												normal:'small_button_normal', down:'small_button_down'
											}
											,
											{
												normal:'square_button_normal', down:'square_button_down'
											}
											
											]
		
		public function StartScreenView() 
		{
			super();
			
			initilize();
		}
		
		private function initilize():void 
		{
			startGameButton = craeteButton('START GAME', 0, 25);
			fieldSize = craeteButton('FIELD SIZE 9x9', 1);
			minesCount = craeteButton('MINES COUNT', 1);
			
			minesCount.scaleX = minesCount.scaleY = fieldSize.scaleX = fieldSize.scaleY = 1.2
			left = craeteButton('<', 2, 25);
			leftMines = craeteButton('<', 2, 25);
			
			right = craeteButton('>', 2, 25);
			rightMines = craeteButton('>', 2, 25);
			
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			aligUI();
		}
		
		private function aligUI():void 
		{
			startGameButton.y = 200;
			fieldSize.y = startGameButton.y + startGameButton.height + PADDING;
			minesCount.y = fieldSize.y + fieldSize.height + PADDING;
			
			centerByX(startGameButton);
			centerByX(fieldSize);
			centerByX(minesCount);
			
			left.x = fieldSize.x - PADDING - left.width;
			right.x = fieldSize.x + fieldSize.width + PADDING;
			
			right.y = left.y = fieldSize.y + (fieldSize.height - left.height)/2;
			
			leftMines.x = minesCount.x - PADDING - leftMines.width;
			rightMines.x = minesCount.x + minesCount.width + PADDING;
			
			rightMines.y = leftMines.y = minesCount.y +  + (minesCount.height - left.height)/2;
		}
		
		private function centerByX(element:DisplayObject):void
		{
			
			element.x = (stage.stageWidth - element.width) / 2;
		}
		
		private function craeteButton(lable:String, textureIndex:int = 1, size:int = 12):Button
		{
			var button:Button = new Button(TextureStore.texturesAtlas.getTexture(buttonAssets[textureIndex].normal), lable, TextureStore.texturesAtlas.getTexture(buttonAssets[textureIndex].down))
			button.fontName = 'Desyrel';
			button.fontBold = true;
			button.fontSize = size;
			button.fontColor = 0xFFFFFF;
			
			addChild(button);
			return button;
		}
		
	}

}