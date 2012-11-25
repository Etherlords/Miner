package view 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import model.CellConstants;
	import model.GameModel;
	import model.MineFieldModel;
	import particles.starParticles.StarParticlesEmmiter;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import utils.GlobalUIContext;
	
	/**
	 * ...
	 * @author 
	 */
	public class MainGaimView extends Sprite 
	{
		private var mineField:MineFieldModel;
		private var mineFieldInstance:Sprite;
		private var gameModel:GameModel;
		private var uiView:GameScreenUI;
		
		public function MainGaimView() 
		{
			super();
			
			var stars:StarParticlesEmmiter = new StarParticlesEmmiter();
			addChild(stars);
			stars.y -= 10;
			
			uiView = new GameScreenUI()
			
			GlobalUIContext.vectorUIContainer.addChild(uiView);
		}
		
		public function initilize(mineField:MineFieldModel, gameModel:GameModel):void
		{
			this.gameModel = gameModel;
			this.mineField = mineField;
			
			uiView.setGameModel(gameModel);
			
			mineFieldInstance = new Sprite();
			
			craeteFieldView();
			
			addChild(mineFieldInstance);
			
			alignUI();
		}
		
		public function reset():void
		{
			if (!mineFieldInstance)
				return;
				
			removeChild(mineFieldInstance);
			
			while (mineFieldInstance.numChildren != 0)
			{
				var child:MineFieldCellView = mineFieldInstance.getChildAt(0) as MineFieldCellView;
				child.removeEventListener(TouchEvent.TOUCH, onTouchEvent);
				mineFieldInstance.removeChildAt(0);
				child.dispose();
				mineFieldInstance.dispose();
			}
			
			Starling.context.clear();
		//	Starling.context.dispose();
			
			initilize(mineField, gameModel);
			
			
		}
		
		private function alignUI():void 
		{
			
			mineFieldInstance.x = int((stage.stageWidth - mineFieldInstance.width) / 2) + 65;
			mineFieldInstance.y = int(Math.round(stage.stageHeight - mineFieldInstance.height) / 2);
		}
		
		public function craeteFieldView():void
		{
			for (var i:int = 0; i < mineField.fieldWidth; i++)
			{
				for (var j:int = 0; j < mineField.fieldHeight; j++)
				{
					var fieldView:MineFieldCellView = new MineFieldCellView(mineField.viewField[i][j]);
					
					fieldView.cellModel.i = i;
					fieldView.cellModel.j = j;
					
					fieldView.addEventListener(TouchEvent.TOUCH, onTouchEvent);
					
					mineFieldInstance.addChild(fieldView);
					fieldView.y = i * (fieldView.width-1);
					fieldView.x = j * (fieldView.width-1);
					
					
				}
			}
			
			GlobalUIContext.vectorStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouse);
		}
		
		private function onRightMouse(e:MouseEvent):void 
		{
			var clickPoint:Point = new Point(e.stageX, e.stageY);
			clickPoint = clickPoint.subtract(new Point(mineFieldInstance.x, mineFieldInstance.y));
			
			var j:int = clickPoint.x / (CellConstants.MINE_FIELD_GABARITE-1);
			var i:int = clickPoint.y / (CellConstants.MINE_FIELD_GABARITE-1);
			
			dispatchEvent(new Event('MineCellRightClicked', false, {i:i, j:j}));
		}
		
		private function onTouchEvent(e:TouchEvent):void 
		{
			var touchTarget:MineFieldCellView = e.currentTarget as MineFieldCellView;
			
			for (var touchIndex:int = 0; touchIndex < e.touches.length; touchIndex++)
			{
				if (e.touches[touchIndex].phase == TouchPhase.BEGAN)
				{
					dispatchEvent(new Event('MineCellClicked', false, {i:touchTarget.cellModel.i, j:touchTarget.cellModel.j}));
				}
			}
		}
		
	}

}