package model 
{
	import patterns.Moderator;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class MineFieldModel extends Moderator 
	{
		
		private var _actualField:Vector.<Vector.<int>>;
		private var _viewField:Vector.<Vector.<MineFieldCellModel>>;
		
		private var _fieldWidth:Number = 0;
		private var _fieldHeight:Number = 0;
		
		public function MineFieldModel() 
		{
			super();
			
		}
		
		public function get actualField():Vector.<Vector.<int>> 
		{
			return _actualField;
		}
		
		public function set actualField(value:Vector.<Vector.<int>>):void 
		{
			_actualField = value;
		}
		
		public function get viewField():Vector.<Vector.<MineFieldCellModel>> 
		{
			return _viewField;
		}
		
		public function set viewField(value:Vector.<Vector.<MineFieldCellModel>>):void 
		{
			_viewField = value;
		}
		
		public function get fieldWidth():Number 
		{
			return _fieldWidth;
		}
		
		public function set fieldWidth(value:Number):void 
		{
			_fieldWidth = value;
		}
		
		public function get fieldHeight():Number 
		{
			return _fieldHeight;
		}
		
		public function set fieldHeight(value:Number):void 
		{
			_fieldHeight = value;
		}
		
	}

}