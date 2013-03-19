package  
{
	import core.states.config.StateConfig;
	import core.states.State;
	import core.states.StatesManager;
	import flash.geom.Rectangle;
	import logic.MainGameController;
	import logic.StartScreenController;
	import model.CellConstants;
	import model.TextureStore;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class MainStarlingScene extends DisplayObjectContainer 
	{
		
		public function MainStarlingScene() 
		{
			super();
			
				
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			var textures:TextureStore = new TextureStore();
			
			textures.addEventListener(Event.COMPLETE, hereGo);
			textures.preload();
		
		}
		
		private function hereGo(e:Event):void 
		{
			var stateManager:StatesManager = new StatesManager(this as DisplayObjectContainer);
			
			var gameStateConfig:StateConfig = new StateConfig('Game', MainGameController);
			var gameState:State = new State(gameStateConfig);
			
			var startScreen:StateConfig = new StateConfig('StartScreen', StartScreenController);
			var startScreenState:State = new State(startScreen);
			
		
			
			stateManager.nextState(startScreenState);
			stateManager.nextState(gameState);
			
			
			stateManager.start();
			
			//Starling.current.root.x = (Starling.current.nativeStage.stageWidth - CellConstants.APPLICATION_WIDTH) / 2;
			//Starling.current.root.y = (Starling.current.nativeStage.stageHeight - CellConstants.APPLICATION_HEIGHT) / 2;
			//Starling.current.viewPort = new Rectangle(Starling.current.root.x, Starling.current.root.y, Starling.current.viewPort.width, Starling.current.viewPort.height);
			//Starling.current.root.x = 10
			//Starling.current.root.y = 0
		}
		
		
		
	}

}