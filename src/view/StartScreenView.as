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
		public var startGameButton:Button;
		public var fieldSize:Button;
		public var left:Button;
		public var right:Button;
		
		public function StartScreenView() 
		{
			super();
			
			initilize();
		}
		
		private function initilize():void 
		{
			startGameButton = craeteButton('START GAME', 0);
			fieldSize = craeteButton('FIELD SIZE 9x9 MINES COUNT 10', 1);
			left = craeteButton('<', 2);
			right = craeteButton('>', 2);
			
			
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
			
			centerByX(startGameButton);
			centerByX(fieldSize);
			
			left.x = fieldSize.x - PADDING - left.width;
			right.x = fieldSize.x + fieldSize.width + PADDING;
			
			right.y = left.y = fieldSize.y;
		}
		
		private function centerByX(element:DisplayObject):void
		{
			
			element.x = (stage.stageWidth - element.width) / 2;
		}
		
		private function craeteButton(lable:String, textureIndex:int = 1):Button
		{
			var button:Button = new Button(TextureStore.textures['button'+textureIndex+'Texture'], lable)
			button.fontName = 'Ubuntu';
			button.fontBold = true;
			button.fontSize = 15;
			addChild(button);
			return button;
		}
		
	}

}