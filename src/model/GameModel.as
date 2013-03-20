package model 
{
	import patterns.Moderator;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class GameModel extends Moderator 
	{
		private var _openedField:int = 0;
		private var _totalField:int = 0;
		private var _foundedMines:int = 0;
		private var _minesCount:int = 0;
		private var _gameTime:Number = 0;
		private var _gameStatus:int = 0;
		
		public function GameModel() 
		{
			super();
			
		}
		
		public function get openedField():int 
		{
			return _openedField;
		}
		
		override public function moderateField(str:String):void 
		{
			super.moderateField(str);
			update();
		}
		
		public function set openedField(value:int):void 
		{
			_openedField = value;
			moderateField('openedField');
		}
		
		public function get totalField():int 
		{
			return _totalField;
		}
		
		public function set totalField(value:int):void 
		{
			_totalField = value;
		}
		
		public function get foundedMines():int 
		{
			return _foundedMines;
		}
		
		public function set foundedMines(value:int):void 
		{
			_foundedMines = value;
			moderateField('foundedMines');
		}
		
		public function get minesCount():int 
		{
			return _minesCount;
		}
		
		public function set minesCount(value:int):void 
		{
			_minesCount = value;
		}
		
		public function get gameTime():Number 
		{
			return _gameTime;
		}
		
		public function set gameTime(value:Number):void 
		{
			_gameTime = value;
			moderateField('gameTime');
		}
		
		public function get gameStatus():int 
		{
			return _gameStatus;
		}
		
		public function set gameStatus(value:int):void 
		{
			_gameStatus = value;
		}
		
	}

}