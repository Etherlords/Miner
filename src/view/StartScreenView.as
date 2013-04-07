package view 
{
	import flash.text.TextFormat;
	import model.TextureStore;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import view.components.AlignContainer;
	import view.components.TextButton;
	
	/**
	 * ...
	 * @author 
	 */
	public class StartScreenView extends Sprite 
	{
		[Inject]
		public var textureStore:TextureStore
		
		static private const PADDING:Number = 5;
		public var minesCount:Sprite;
		public var rightMines:Sprite;
		public var leftMines:Sprite;
		public var startGameButton:Sprite;
		public var fieldSize:Sprite;
		public var left:Sprite;
		public var right:Sprite;
		public var difficle:Sprite;
		public var difficleLable:Sprite;
		private var options:Sprite;
		private var credits:Sprite;
		private var fieldSizeSection:AlignContainer;
		private var minesCounSection:AlignContainer
		private var difficleSection:AlignContainer
		private var buttonsGroup:AlignContainer
		
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
											;
											
											
		
		public function StartScreenView() 
		{
			inject(this);
			super();
			
			initilize();
		}
		
		private function initilize():void 
		{
			startGameButton = craeteButton('START GAME', 1, 25);
			options = craeteButton('OPTIONS', 1, 25);
			fieldSize = craeteButton('FIELD 9x9', 1, 25);
			minesCount = craeteButton('MINES COUNT', 1, 25);
			difficle = craeteButton('CHANGE DIFFICLE', 1, 25);
			credits = craeteButton('CREDITS', 1, 25);

			left = craeteButton('<', 2, 25);
			leftMines = craeteButton('<', 2, 25);
			
			right = craeteButton('>', 2, 25);
			rightMines = craeteButton('>', 2, 25);
			
			difficleLable = craeteButton('SOFT', 2, 10);
			
			difficleSection = new AlignContainer();
			difficleSection.addElements(difficle, difficleLable);
				
			fieldSizeSection = new AlignContainer();
			fieldSizeSection.addElements(left, fieldSize, right);
			
			minesCounSection = new AlignContainer();
			minesCounSection.addElements(leftMines, minesCount, rightMines);
			
			buttonsGroup = new AlignContainer(0, AlignContainer.BOTTOM);
			buttonsGroup.addElements(startGameButton, options, fieldSizeSection, minesCounSection, difficleSection, credits);
			
		
			
			addChild(buttonsGroup);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			aligUI();
		}
		
		private function aligUI():void 
		{
			buttonsGroup.y = (stage.stageHeight - buttonsGroup.height) / 2;
			fieldSizeSection.align();
			minesCounSection.align();
			difficleSection.align();
			buttonsGroup.align();
			
			
			centerByX(startGameButton);
			centerByX(fieldSizeSection);
			centerByX(minesCounSection);
			centerByX(difficleSection);
			centerByX(options);
			centerByX(credits);

			difficleLable.y = difficle.y +  + (difficle.height - difficleLable.height) / 2;
		}
		
		private function centerByX(element:DisplayObject):void
		{
			
			element.x = (stage.stageWidth - element.width) / 2;
		}
		
		private function craeteButton(lable:String, textureIndex:int = 1, size:int = 12):Sprite
		{
			//var button:Button = new Button(textureStore.getTexture(buttonAssets[textureIndex].normal), lable, textureStore.getTexture(buttonAssets[textureIndex].down))
			//button.fontName = 'Desyrel';
			//button.fontBold = true;
			//button.fontSize = size;
			//button.fontColor = 0xFFFFFF;
			
			var format:TextFormat = new TextFormat('mini', size, 0xFFFFFF, false, false);
			var button:TextButton = new TextButton(lable, format);
			
			//addChild(button);
			
			button.addEventListener(Event.CHANGE, onButtonChange);
			
			return button;
		}
		
		private function onButtonChange(e:Event):void 
		{
			aligUI();
		}
		
	}

}