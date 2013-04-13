package view 
{
	import starling.filters.BlurFilter;
	import flash.text.TextFormat;
	import model.TextureStore;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
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
		public var minesCount:DisplayObjectContainer;
		public var rightMines:DisplayObjectContainer;
		public var leftMines:DisplayObjectContainer;
		public var startGameButton:DisplayObjectContainer;
		public var fieldSize:DisplayObjectContainer;
		public var left:DisplayObjectContainer;
		public var right:DisplayObjectContainer;
		public var difficle:DisplayObjectContainer;
		public var difficleLable:DisplayObjectContainer;
		private var options:DisplayObjectContainer;
		private var credits:DisplayObjectContainer;
		private var fieldSizeSection:AlignContainer;
		private var minesCounSection:AlignContainer
		private var difficleSection:AlignContainer
		private var buttonsGroup:AlignContainer
		
		private var buttonAssets:Array = [
											{
												normal:'big_button_normal', down:'big_button_down'
											}
											,
											{
												normal:'big_button_normal', down:'big_button_down'
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
			var back:Image = new Image(textureStore.getTexture('bg.png'));
			addChild(back);
			
			var fontSize:int = 30;
			startGameButton = craeteButton('START GAME', 1, fontSize);
			options = craeteButton('OPTIONS', 1, fontSize);
			fieldSize = craeteButton('FIELD 9x9', 1, fontSize);
			minesCount = craeteButton('MINES COUNT', 1, fontSize);
			difficle = craeteButton('CHANGE DIFFICLE', 1, fontSize);
			credits = craeteButton('CREDITS', 1, fontSize);

			left = craeteButton('<', 1, fontSize);
			leftMines = craeteButton('<', 1, fontSize);
			
			right = craeteButton('>', 1, fontSize);
			rightMines = craeteButton('>', 1, fontSize);
			
			difficleLable = craeteButton('SOFT', 1, fontSize);
			
			difficleSection = new AlignContainer();
			difficleSection.addElements(difficle);
			//difficleSection.addElements(difficle, difficleLable);
				
			fieldSizeSection = new AlignContainer();
			fieldSizeSection.addElements(fieldSize);
			//fieldSizeSection.addElements(left, fieldSize, right);
			
			minesCounSection = new AlignContainer();
			minesCounSection.addElements(minesCount);
			//minesCounSection.addElements(leftMines, minesCount, rightMines);
			
			buttonsGroup = new AlignContainer(5, AlignContainer.BOTTOM);
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
		
		private function craeteButton(lable:String, textureIndex:int = 1, size:int = 12):DisplayObjectContainer
		{
			var button:Button = new Button(textureStore.getTexture(buttonAssets[textureIndex].normal), lable, textureStore.getTexture(buttonAssets[textureIndex].down))
			button.fontName = 'a_LCDNova';
			button.fontBold = true;
			button.fontSize = size;
			button.fontColor = 0xAAA7A5;
			//button.mTextField.filter = new BlurFilter(5, 5, 3);
			
			//var format:TextFormat = new TextFormat('mini', size, 0xFFFFFF, false, false);
			//var button:TextButton = new TextButton(lable, format);
			
			//addChild(button);
			
			//button.addEventListener(Event.CHANGE, onButtonChange);
			
			return button;
		}
		
		private function onButtonChange(e:Event):void 
		{
			aligUI();
		}
		
	}

}