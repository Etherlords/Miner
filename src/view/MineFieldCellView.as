package view 
{
	import core.view.skin.Skin;
	import flash.display.BitmapData;
	import model.CellConstants;
	import model.MineFieldCellModel;
	import model.TextureStore;
	import patterns.events.LazyModeratorEvent;
	import starling.display.BlendMode;
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
		private static const FIELD_TEXTURE_IDENT:String = 'fieldTexture';
		public var cellModel:MineFieldCellModel;
		private var lable:TextField;
		
		private var lableColors:Array = [0x000022, 0x000077, 0x0000EE, 0x33A3FF, 0x33CC00, 0x00AA00, 0xB6CC00, 0xF7CC00, 0xFF0000]; 
		
		private var updateMap:Object;
		private var background:Image;
		private var flag:Image;
		
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
			
			background = new Image(TextureStore.textures[FIELD_TEXTURE_IDENT + 0]);
			
			var scaleFactor:Number = CellConstants.MINE_FIELD_GABARITE / background.width;
			
			
			flag = new Image(TextureStore.textures['flagTexture']);
			addChild(background);
			
			
			background.smoothing = TextureSmoothing.TRILINEAR;
			flag.smoothing = TextureSmoothing.TRILINEAR;
			
			lable = new TextField(CellConstants.MINE_FIELD_GABARITE, CellConstants.MINE_FIELD_GABARITE, '', 'Ubuntu', CellConstants.MINE_FIELD_GABARITE * 0.85, 0x0, true);
			lable.autoScale = true
			
			lable.touchable = false;
			flag.touchable = false;
			
			background.scaleX = background.scaleY = flag.scaleX = flag.scaleY = scaleFactor;
			
			//this.flatten();
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
			flatten();
			
		}
		
		private function openState():void
		{
			
			if (cellModel.fieldStatus != CellConstants.OPEN_FIELD && cellModel.fieldStatus != CellConstants.MINED_FIELD)
			{
				lable.color = lableColors[cellModel.fieldStatus];
				lable.text = cellModel.fieldStatus.toString();
				
				if (!contains(lable))
					addChild(lable);
			}
			else
			{
				if(contains(lable))
					removeChild(lable);
					
				lable.text = '';
			}
				
			alignUI();
			
		}
		
		private function showMine():void 
		{
			
			var mineImage:Image = new Image(TextureStore.textures['mine']);
			mineImage.smoothing = TextureSmoothing.TRILINEAR;
			mineImage.touchable = false;
			mineImage.scaleX = mineImage.scaleY = CellConstants.MINE_FIELD_GABARITE / mineImage.width;
			mineImage.x = (CellConstants.MINE_FIELD_GABARITE - mineImage.width) / 2;
			mineImage.y = (CellConstants.MINE_FIELD_GABARITE - mineImage.height) / 2;
			
			addChild(mineImage);
		}
		
		private function drawView():void
		{
			
			
			background.texture = TextureStore.textures[FIELD_TEXTURE_IDENT + cellModel.viewState]
			
			if (cellModel.isFlagged && cellModel.viewState != CellConstants.OPEN_STATE)
				addChild(flag)
			else
				removeChild(flag);
				
			if(contains(lable))
				this.setChildIndex(lable, this.numChildren - 1);
				
			flatten();
		}
		
	}

}