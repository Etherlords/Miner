package  
{
	import core.states.config.StateConfig;
	import core.states.State;
	import core.states.StatesManager;
	import flash.events.IEventDispatcher;
	import logic.MainGameController;
	import logic.StartScreenController;
	import model.TextureStore;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import utils.GlobalUIContext;
	
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class MainStarlingScene extends DisplayObjectContainer 
	{
		[Inject(id=identinjection)]
		public var texturesStore:TextureStore
		
		[Inject]
		public var test:IEventDispatcher
		
		public function MainStarlingScene() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			new ApplicationBootstrap().launch();
			inject(this);
			
			trace(test, '####');
			
			texturesStore.addEventListener(Event.COMPLETE, hereGo);
			texturesStore.preload();
		}
		
		private function hereGo(e:*):void 
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