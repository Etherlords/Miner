package view.components 
{
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class AlignContainer extends Sprite 
	{
		public static const RIGHT:uint = 0;
		public static const BOTTOM:uint = 1;
		
		protected var elements:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		
		protected var alignStrategy:Function;
		protected var padding:Number;
		protected var alignType:uint;
		protected var usingFlatten:Boolean;
		
		public function AlignContainer(padding:Number = 0, align:uint = RIGHT, usingFlatten:Boolean = false ) 
		{
			super();
			this.usingFlatten = usingFlatten;
			
			this.alignType = align;
			this.padding = padding;
			
			initilzie();
		}
		
		public function addElements(...rest:Array):void
		{
			var l:uint = rest.length;
			for (var i:uint = 0; i < l; ++i)
			{
				addElement(rest[i], false);
			}
			
			align();
		}
		
		public function addElement(element:DisplayObject, isAlign:Boolean = true):void
		{
			elements.push(element);
			
			addChild(element);
			
			if (isAlign)
				align();
		}
		
		private function initilzie():void 
		{
			alignStrategy = alignType == RIGHT? alignToRight:alignToBottom;
			
			if(usingFlatten)
				flatten();
		}
		
		public function align():void
		{
			var anchorn:Point = new Point(0, 0);
			var l:uint = elements.length;
			for (var i:uint = 0; i < l; ++i)
			{
				alignStrategy(elements[i], anchorn);
			}
			
			if(usingFlatten)
				flatten();
		}
		
		private function placeElement(element:DisplayObject, anchorn:Point):void
		{
			if (element.x != anchorn.x)
			{
				
				element.x = anchorn.x;
			}
				
			if (element.y != anchorn.y)
			{
				
				element.y = anchorn.y;
			}
		}
		
		private function alignToBottom(element:DisplayObject, anchorn:Point):void
		{
			placeElement(element, anchorn);
			anchorn.y += element.height + padding;
		}
		
		private function alignToRight(element:DisplayObject, anchorn:Point):void
		{
			placeElement(element, anchorn);
			anchorn.x += Math.floor(element.width) + padding;
		}
		
	}

}