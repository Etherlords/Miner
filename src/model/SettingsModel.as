package model 
{
	/**
	 * ...
	 * @author 
	 */
	public class SettingsModel 
	{
		public var fieldWidth:Number;
		public var fieldHeight:Number;
		public var minesCount:Number;
		
		public function SettingsModel() 
		{
			
		}
		
		private static var _instance:SettingsModel
		
		static public function get instance():SettingsModel 
		{
			if (!_instance)
				_instance = new SettingsModel();
			
			return _instance;
		}
		
		
	}

}