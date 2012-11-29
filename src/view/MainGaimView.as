package view 
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import model.CellConstants;
	import model.GameModel;
	import model.MineFieldModel;
	import particles.starParticles.StarParticlesEmmiter;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
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
		private var fieldWith:Number;
		private var fieldHeight:Number;
		
		private var mouseTracker:Point = new Point(0, 0);
		private var trackTarget:MineFieldCellView;
		private var scaleFactor:Number;
		
		public var fullScreen:SimpleButton;
		
		public function MainGaimView() 
		{
			super();
			
			
			
			var stars:StarParticlesEmmiter = new StarParticlesEmmiter();
			addChild(stars);
			stars.y -= 10;
			
			uiView = new GameScreenUI()
			
			GlobalUIContext.vectorUIContainer.addChild(uiView);
			
		
			fullScreen = uiView.fullScreen;
			
			
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
				//child.removeEventListener(TouchEvent.TOUCH, onTouchEvent);
				mineFieldInstance.removeChildAt(0);
				//child.dispose();
				//mineFieldInstance.dispose();
			}
			
		//	Starling.context.clear();
		//	Starling.context.dispose();
			mineFieldInstance = null;
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
					
					//fieldView.addEventListener(TouchEvent.TOUCH, onTouchEvent);
					
					mineFieldInstance.addChild(fieldView);
					fieldView.y = i * (fieldView.width);
					fieldView.x = j * (fieldView.height);
					fieldView.touchable = false;
				}
			}
			
			scaleFactor = fieldView.scaleFactor
			
			fieldWith = fieldView.width
			fieldHeight= fieldView.height
			GlobalUIContext.vectorStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouse);
			GlobalUIContext.vectorStage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			mineFieldInstance.flatten();
			
			mineFieldInstance.touchable = false;
			this.touchable = false;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			
			var j:int = (e.localX - mineFieldInstance.x - fieldWith / 8 / scaleFactor) / fieldWith;
			var i:int = (e.localY - mineFieldInstance.y) / fieldHeight;
			
			if (i >= mineField.fieldWidth)
				return;
				
			if (j >= mineField.fieldHeight)
				return;
				
			if (i < 0 || j < 0)
				return;
			
			dispatchEvent(new Event('MineCellClicked', false, { i:i, j:j } ));
				mineFieldInstance.flatten();
		}
		

		private function onRightMouse(e:MouseEvent):void 
		{
			
			var j:int = (e.localX - mineFieldInstance.x - fieldWith / 8 / scaleFactor) / fieldWith;
			var i:int = (e.stageY - mineFieldInstance.y) / fieldHeight;
			
			if (i >= mineField.fieldWidth)
				return;
				
			if (j >= mineField.fieldHeight)
				return;
				
			if (i < 0 || j < 0)
				return;
			
			dispatchEvent(new Event('MineCellRightClicked', false, { i:i, j:j } ));
				mineFieldInstance.flatten();
			
			
		}
		
		private function onTouchEvent(e:TouchEvent):void 
		{
			
			return;
			var touchTarget:MineFieldCellView = e.currentTarget as MineFieldCellView;
		
			for (var touchIndex:int = 0; touchIndex < e.touches.length; touchIndex++)
			{
				if (e.touches[touchIndex].phase == TouchPhase.BEGAN)
				{
					dispatchEvent(new Event('MineCellClicked', false, { i:touchTarget.cellModel.i, j:touchTarget.cellModel.j } ));
					mineFieldInstance.flatten();
				}
				
				if (e.touches[touchIndex].phase == TouchPhase.HOVER)
				{
					mouseTracker.x = e.touches[touchIndex].globalX;
					mouseTracker.y = e.touches[touchIndex].globalY;
					trackTarget = touchTarget;
					
				}
			}
		}
		
	}

}