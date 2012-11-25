package  model
{
	import patterns.Moderator;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class MineFieldCellModel extends Moderator 
	{
		private var _fieldStatus:int = 0;
		private var _viewState:int = 0;
		private var _isFlagged:Boolean = false;
		
		public var i:int;
		public var j:int;
		
		public function MineFieldCellModel(fieldStatus:int, viewState:int) 
		{
			super();
			_viewState = viewState;
			_fieldStatus = fieldStatus;
			
		}
		
		public function get fieldStatus():int 
		{
			return _fieldStatus;
		}
		
		public function set fieldStatus(value:int):void 
		{
			_fieldStatus = value;
			
		}
		
		public function get viewState():int 
		{
			return _viewState;
		}
		
		public function set viewState(value:int):void 
		{
			
			_viewState = value;
			moderateField('viewState');
		}
		
		public function get isFlagged():Boolean 
		{
			return _isFlagged;
		}
		
		public function set isFlagged(value:Boolean):void 
		{
			_isFlagged = value;
			moderateField('isFlagged');
		}
		
	}

}