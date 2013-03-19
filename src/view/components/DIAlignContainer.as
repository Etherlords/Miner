package view.components 
{
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class DIAlignContainer extends Sprite 
	{
		public static const TOP:uint = 		0;
		public static const LEFT:uint = 	1;
		public static const RIGHT:uint = 	2;
		public static const BOTTOM:uint = 	3;
		
		private var element1:Sprite;
		private var element2:Sprite;
		private var padding:Number;
		private var align:uint;
		
		public function DIAlignContainer(element1:Sprite, element2:Sprite, align:uint = LEFT, padding:Number = 0) 
		{
			this.align = align;
			this.padding = padding;
			this.element2 = element2;
			this.element1 = element1;
			initilize();
		}
		
		private function initilize():void 
		{
			this.addChild(element1);
			this.addChild(element2);
			
			
		}
		
		private function bottomAlign():void
		{
			
		}
		
		private function rightAlign():void
		{
			
		}
		
		private function leftAlign():void
		{
			
		}
		
		private function topAlign():void
		{
			
		}
		
	}

}