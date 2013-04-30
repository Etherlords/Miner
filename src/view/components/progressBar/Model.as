package view.components.progressBar 
{
	import flash.display.BitmapData;
	import patterns.Moderator;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class Model extends Moderator 
	{
		public var bgPattern:BitmapData;
		public var progressPattern:BitmapData;
		public var outLine:BitmapData;
		
		private var _progress:Number = 0;
		
		public function Model() 
		{
			super();
			
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		public function set progress(value:Number):void 
		{
			_progress = value;
			moderateField('progress');
		}
		
	}

}