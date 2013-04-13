package view.text 
{
	import feathers.controls.Button;
	import feathers.controls.text.TextFieldTextRenderer;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class OutlinedTextRenderer extends TextFieldTextRenderer 
	{
		private var buttonLink:Button;
		
		public function OutlinedTextRenderer() 
		{
			super();
			
		}
		
		override protected function addedToStageHandler(event:Event):void 
		{
			super.addedToStageHandler(event);
			
			buttonLink = parent as Button;
		}
		
		override public function get textFormat():TextFormat 
		{
			return super.textFormat;
		}
		
		override public function set textFormat(value:TextFormat):void 
		{
			super.textFormat = value;
			
			if (buttonLink && buttonLink.currentState == Button.STATE_DOWN)
			{
				textField.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 4, 1)];
			}
			else if (textField.filters)
				textField.filters = null;
				
			
		}
		
		override protected function enterFrameHandler(event:Event):void 
		{
			super.enterFrameHandler(event);
			
				
		}
		
	}

}