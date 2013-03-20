package view
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import model.CellConstants;
	import model.GameModel;
	import model.MineFieldModel;
	import particles.starParticles.StarParticlesEmmiter;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import utils.GlobalUIContext;
	import view.components.Background;
	
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
		private var _zoom:int = 0;
		private var mouseTracker:Point = new Point(0, 0);
		private var trackTarget:MineFieldCellView;
		private var scaleFactor:Number;
		private var stars:StarParticlesEmmiter;
		
		public var fullScreen:Button;
		public var backButton:Button;
		
		public function MainGaimView()
		{
			super();
			
			var bg:Background = new Background();
			addChild(bg);
			stars = new StarParticlesEmmiter();
			addChild(stars);
			stars.y -= 10;
			
			uiView = new GameScreenUI()
			
			addChild(uiView);
			
			fullScreen = uiView.fullScreen;
			backButton = uiView.backButton;
		
		}
		
		public function set zoom(value:int):void
		{
			_zoom = value;
			
			if (_zoom > 100)
				_zoom = 100;
			if (_zoom < -96)
				_zoom = -96;
			
			trace(1 + _zoom);
			//mineFieldInstance.scaleX = mineFieldInstance.scaleY = 1 + _zoom / 100;
			//mineFieldInstance.flatten();
		}
		
		public function get zoom():int
		{
			return _zoom;
		}
		
		public function deactivate():void
		{
			//uiView.deactivate();
			
			clean();
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
			
			GlobalUIContext.vectorStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouse);
			GlobalUIContext.vectorStage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			GlobalUIContext.vectorStage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function clean():void
		{
			
			GlobalUIContext.vectorStage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouse);
			GlobalUIContext.vectorStage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			GlobalUIContext.vectorStage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			if (!mineFieldInstance)
				return;
			
			removeChild(mineFieldInstance);
			
			while (mineFieldInstance.numChildren != 0)
			{
				var child:MineFieldCellView = mineFieldInstance.getChildAt(0) as MineFieldCellView;
				
				mineFieldInstance.removeChildAt(0);
				child.dispose();
				
			}
			mineFieldInstance.dispose();
			mineFieldInstance = null;
		}
		
		public function reset():void
		{
			if (mineFieldInstance)
				clean();
			
			if (gameModel)
				initilize(mineField, gameModel);
		}
		
		private function alignUI():void
		{
			mineFieldInstance.x = int((CellConstants.APPLICATION_WIDTH - mineFieldInstance.width) / 2);
			mineFieldInstance.y = int(Math.round(CellConstants.APPLICATION_HEIGHT - mineFieldInstance.height) / 2);
			
			if (CellConstants.APPLICATION_WIDTH > CellConstants.APPLICATION_HEIGHT)
				mineFieldInstance.x = uiView.width + 10;
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
					fieldView.y = i * (CellConstants.MINE_FIELD_GABARITE);
					fieldView.x = j * (CellConstants.MINE_FIELD_GABARITE);
					fieldView.touchable = false;
				}
			}
			scaleFactor = fieldView.scaleFactor
			
			mineFieldInstance.flatten();
			
			mineFieldInstance.touchable = false;
			//this.touchable = false;
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{
			zoom += e.delta;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			var i:int = (e.localY - mineFieldInstance.y) / CellConstants.MINE_FIELD_GABARITE;
			var j:int = Math.floor((e.localX - mineFieldInstance.x) / CellConstants.MINE_FIELD_GABARITE);
			
			if (i >= mineField.fieldWidth)
				return;
			
			if (j >= mineField.fieldHeight)
				return;
			
			if (i < 0 || j < 0)
				return;
			
			dispatchEvent(new Event('MineCellClicked', false, {i: i, j: j}));
			mineFieldInstance.flatten();
		}
		
		private function onRightMouse(e:MouseEvent):void
		{
			var i:int = (e.stageY - mineFieldInstance.y) / CellConstants.MINE_FIELD_GABARITE;
			var j:int = Math.floor((e.localX - mineFieldInstance.x) / CellConstants.MINE_FIELD_GABARITE);
			
			if (i >= mineField.fieldWidth)
				return;
			
			if (j >= mineField.fieldHeight)
				return;
			
			if (i < 0 || j < 0)
				return;
			
			dispatchEvent(new Event('MineCellRightClicked', false, {i: i, j: j}));
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
					dispatchEvent(new Event('MineCellClicked', false, {i: touchTarget.cellModel.i, j: touchTarget.cellModel.j}));
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