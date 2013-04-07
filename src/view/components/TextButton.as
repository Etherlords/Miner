package view.components 
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class TextButton extends Sprite 
	{
		private var textValue:String;
		private var background:Image;
		private var format:TextFormat;
		
		public function TextButton(textValue:String, format:TextFormat) 
		{
			super();
			this.format = format;
			this.textValue = textValue;
			
			initilize();
		}
		
		public function set text(value:String):void
		{
			textValue = value;
			
			
			redraw();
		}
		
		public function get text():String
		{
			return textValue;
		}
		
		private function initilize():void 
		{
			redraw();
			
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if(e.touches[0].phase == TouchPhase.BEGAN)
				dispatchEventWith(Event.TRIGGERED);
		}
		
		private function redraw():void
		{
			if (background)
			{
				removeChild(background);
				background.dispose();
				background = null;
			}
			
			var text:TextField = new TextField();
			text.defaultTextFormat = format
			text.text = textValue;
			text.visible = false;
			text.filters = [new GlowFilter(0x10ACFF, 0.4, 5, 5, 4, 3)];
			text.autoSize = TextFieldAutoSize.LEFT;
			//GlobalUIContext.vectorStage.addChild(text);
			
			var texture:BitmapData = new BitmapData(text.width, text.height, true, 0x0);
			texture.draw(text);
			
			//GlobalUIContext.vectorStage.removeChild(text);
			
			if (!background)
			{
				background = new Image(Texture.fromBitmapData(texture));
			}
			else
				background.texture = Texture.fromBitmapData(texture);
				
			
			
			text = null;
			texture.dispose();
			
			addChild(background);
			flatten();
			
			dispatchEventWith(Event.CHANGE);
		}
		
	}

}