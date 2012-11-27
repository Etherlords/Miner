package  
{
	import core.states.config.StateConfig;
	import core.states.State;
	import core.states.StatesManager;
	import flash.geom.Rectangle;
	import logic.MainGameController;
	import logic.StartScreenController;
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
			
			
			
			var stateManager:StatesManager = new StatesManager(this as DisplayObjectContainer);
			
			var gameStateConfig:StateConfig = new StateConfig('Game', MainGameController);
			var gameState:State = new State(gameStateConfig);
			
			var startScreen:StateConfig = new StateConfig('StartScreen', StartScreenController);
			var startScreenState:State = new State(startScreen);
			
		
			
			stateManager.nextState(startScreenState);
			stateManager.nextState(gameState);
			
			stateManager.start();
			
			Starling.current.root.x = (Starling.current.nativeStage.stageWidth - 1024) / 2;
			Starling.current.root.y = (Starling.current.nativeStage.stageHeight - 768) / 2;
			Starling.current.viewPort = new Rectangle(Starling.current.root.x, Starling.current.root.y, 1024, 768);
			Starling.current.root.x = 10
			Starling.current.root.y = 0
		}
		
		
		
	}

}