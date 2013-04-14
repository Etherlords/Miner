package view.components 
{
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import model.TextureStore;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Nikro
	 */
	public class Alert extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		private var image:Scale9Image;
		private var lablesContainer:Sprite;
		private var parts:Vector.<Label> = new Vector.<Label>;
		
		[Inject]
		public var textureStore:TextureStore;
		
		public function Alert(width:Number = 0, height:Number = 0) 
		{
			inject(this);
			_height = height;
			_width = width;
			initilize();
		}
		
		private function initilize():void 
		{
			image = new Scale9Image(new Scale9Textures(textureStore.getTexture('big_button_normal'), new Rectangle(6, 6, 300, 30)));
			lablesContainer = new Sprite();
			addChild(image);
			addChild(lablesContainer);
		}
		
		public function set text(value:String):void
		{
			var lable:Label;
			var lablesParts:Array = value.split(String.fromCharCode('10'));

			for (var i:int = 0; i < lablesParts.length; i++)
			{
				if (parts.length > i)
					lable = parts[i]
				else
					lable = new Label();
				
				lable.text = lablesParts[i];
				lable.addEventListener(TouchEvent.TOUCH, onTouch);
				
				lablesContainer.addChild(lable);
				parts.push(lable);
			}
			
			if (lable)
				lable.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				var lable:Label = e.target as Label;
				
				if (lable)
				{
					lable.invalidate();
					var evntTag:String = 'event:';
					var evntIndex:int = lable.text.indexOf(evntTag);
					if (evntIndex != -1)
					{
						var i:int = evntIndex + evntTag.length;
						var event:String = lable.text.substring(i, lable.text.indexOf('>', i) - 1);
						
						if (event.length)
							dispatchEventWith(event);
					}
				}
			}
		}
		
		private function onResize(e:Event):void 
		{
			resize();
		}
		
		public override function get width():Number 
		{
			return _width;
		}
		
		public override function set width(value:Number):void 
		{
			_width = value;
			resize();
		}
		
		public override function get height():Number 
		{
			return _height;
		}
		
		public override function set height(value:Number):void 
		{
			_height = value;
			resize();
		}
		
		private function resize():void 
		{
			var lable:Label
			var __y:Number = 0;
			for (var i:int = 0; i < parts.length; i++)
			{
				lable = parts[i];
				
				lable.x = -lable.width / 2;
				lable.y = __y;
				
				__y = lable.y + lable.height;
			}
			
			_width = lablesContainer.width;
			_height = lablesContainer.height;
			
			lablesContainer.x = lablesContainer.width / 2;
			//lablesContainer.y = lablesContainer.height / 2;
			
			image.width = _width
			image.height = _height
			
			if (parent) {
				
				this.x = (parent.width - this.width) / 2;
				this.y = (parent.height - this.height) / 2;
			}
		}
		
	}

}