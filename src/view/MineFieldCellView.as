package view 
{
	import model.CellConstants;
	import model.MineFieldCellModel;
	import model.TextureStore;
	import patterns.events.LazyModeratorEvent;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	
	/**
	 * ...
	 * @author Nikro
	 */
	public class MineFieldCellView extends Sprite
	{	
		private static const FIELD_TEXTGURES:Array = ['cell_normal', 'cell_down', 'cell_bomb'];
		private static const MINE_TEXTURE:String = 'gnomemines'
		private static const FLAG_TEXTURE:String = 'flag'
		
		public var cellModel:MineFieldCellModel;
		private var lable:Image;
		
		private var lableColors:Array = [0x0033FF, 0x222277, 0x0000EE, 0x33A3FF, 0x33CC00, 0x00AA00, 0xB6CC00, 0xF7CC00, 0xFF0000]; 
		
		private var updateMap:Object;
		private var background:Image;
		private var flag:Image;
		public var scaleFactor:Number;
		
		public function MineFieldCellView(cellModel:MineFieldCellModel) 
		{
			this.cellModel = cellModel;
			
			
			
			initilize();
		}
		
		private function initilize():void 
		{
			cellModel.addEventListener(LazyModeratorEvent.UPDATE_EVENT, processViewUpdate);
			
			updateMap = {  isFlagged:drawView, viewState:changeState };
			
			
			
			createView();
			drawView();
			alignUI();
		}
		
		private function createView():void 
		{
			
			background = new Image(TextureStore.texturesAtlas.getTexture(FIELD_TEXTGURES[0]));
			
			scaleFactor = CellConstants.MINE_FIELD_GABARITE / background.width;
			
			lable = new Image(TextureStore.numbers[0]);
			flag = new Image(TextureStore.texturesAtlas.getTexture(FLAG_TEXTURE));
			addChild(background);
			
			
			background.smoothing = TextureSmoothing.TRILINEAR;
			flag.smoothing = TextureSmoothing.TRILINEAR;
			lable.smoothing = TextureSmoothing.TRILINEAR;
			
			lable.touchable = false;
			flag.touchable = false;
			background.touchable = false;
			
			background.width = Math.ceil(background.width * scaleFactor);
			background.height = Math.ceil(background.height * scaleFactor);
			flag.width = Math.ceil(flag.width * scaleFactor);
			flag.height = Math.ceil(flag.height * scaleFactor);
			
			
			if(scaleFactor < 0.94)
				lable.scaleX = lable.scaleY = scaleFactor * 3
		}
		
		private function alignUI():void
		{
			lable.x = (CellConstants.MINE_FIELD_GABARITE - lable.width) / 2;
			lable.y = (CellConstants.MINE_FIELD_GABARITE - lable.height) / 2 - 2;
		}
		
		private function processViewUpdate(e:LazyModeratorEvent):void 
		{
			var fieldsList:Object = cellModel.getFieldsList();
			
			for (var field:String in fieldsList)
			{
				if(updateMap.hasOwnProperty(field))
					updateMap[field]();
			}
		}
		
		private function changeState():void
		{
			
			drawView();
			
			
			
			if (cellModel.viewState == CellConstants.OPEN_STATE)
				openState();
				
			if (cellModel.viewState == CellConstants.MINE_FINDED_STATE)
			{
				showMine();
			}
			
			//flatten();
			
		}
		
		private function openState():void
		{
			
			if (cellModel.fieldStatus != CellConstants.OPEN_FIELD && cellModel.fieldStatus != CellConstants.MINED_FIELD)
			{
				//lable.color = lableColors[cellModel.fieldStatus];
				lable.texture = TextureStore.numbers[cellModel.fieldStatus];
				
				//background.texture
				if (!contains(lable))
					addChild(lable);
				
				
			}
			else
			{
				if(contains(lable))
					removeChild(lable);
			}
				
			alignUI();
			
		}
		
		private function showMine():void 
		{
			
			var mineImage:Image = new Image(TextureStore.texturesAtlas.getTexture(MINE_TEXTURE));
			mineImage.smoothing = TextureSmoothing.TRILINEAR;
			mineImage.touchable = false;
			mineImage.scaleX = mineImage.scaleY = CellConstants.MINE_FIELD_GABARITE / mineImage.width;
			mineImage.x = (CellConstants.MINE_FIELD_GABARITE - mineImage.width) / 2;
			mineImage.y = (CellConstants.MINE_FIELD_GABARITE - mineImage.height) / 2;
			
			addChild(mineImage);
		}
		
		private function drawView():void
		{
			
			
			background.texture = TextureStore.texturesAtlas.getTexture(FIELD_TEXTGURES[cellModel.viewState]);
			
			if (cellModel.isFlagged && cellModel.viewState != CellConstants.OPEN_STATE)
				addChild(flag)
			else
				removeChild(flag);
				
			if(contains(lable))
				this.setChildIndex(lable, this.numChildren - 1);
				
			//flatten();
		}
		
	}

}