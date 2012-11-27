package view 
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
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
		private var mouseTracker:Point = new Point(0, 0);
		private var trackTarget:MineFieldCellView;
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
			
			fieldWith = fieldView.width - 1;
			GlobalUIContext.vectorStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouse);
			
			//mineFieldInstance.flatten();
		}
		

		private function onRightMouse(e:MouseEvent):void 
		{
			if (trackTarget is MineFieldCellView)
			{
				var touchTarget:MineFieldCellView = trackTarget as MineFieldCellView;
				dispatchEvent(new Event('MineCellRightClicked', false, { i:touchTarget.cellModel.i, j:touchTarget.cellModel.j } ));
				return;
			}
			
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