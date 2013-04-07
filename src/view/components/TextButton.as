package view.components 
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
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
		private var touch:Touch;
		
		private var hovered:Boolean = false;
		
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
			
			 Mouse.cursor = (e.interactsWith(this)) ? 
                MouseCursor.BUTTON : MouseCursor.AUTO;
			
			touch = e.getTouch(this);
			if (!touch)
				return;
				
			
				
			if(touch.phase == TouchPhase.BEGAN)
				dispatchEventWith(Event.TRIGGERED);
			
		}
		
		override public function render(support:RenderSupport, parentAlpha:Number):void 
		{
			
			super.render(support, parentAlpha);
			
			if (!touch)
			{
				
				onOut();
				return;
			}
				
			var buttonRect:Rectangle = getBounds(stage);
			if (touch.globalX < buttonRect.x - 1 ||
                    touch.globalY < buttonRect.y - 1 ||
                    touch.globalX > buttonRect.x + buttonRect.width + 1 ||
                    touch.globalY > buttonRect.y + buttonRect.height + 1)
                {
                    onOut()
                }
				else
					onHover()
			
			
		}
		
		private function onHover():void 
		{
			if (hovered)
				return
			hovered = true;
			trace('hover');
			filter = new BlurFilter(2, 1, 4);
			//flatten();
		}
		
		private function onOut():void 
		{
			if (!hovered)
				return;
				
			hovered = false
			filter = null;
			flatten();
			trace('out');
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
			text.filters = [new GlowFilter(0x10ACFF, 0.8, 5, 5, 4, 3)];
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
			//flatten();
			
			dispatchEventWith(Event.CHANGE);
		}
		
	}

}