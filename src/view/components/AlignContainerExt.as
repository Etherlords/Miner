package view.components 
{
	/**
	 * ...
	 * @author Nikro
	 */
	public class AlignContainerExt extends AlignContainer 
	{
		
		public function AlignContainerExt(padding:Number = 0, align:uint = AlignContainer.RIGHT, usingFlatten:Boolean = false ) 
		{
			super(padding, align, usingFlatten);
		}
		
		override public function get x():Number 
		{
			return elements[0]? Math.floor(elements[0].x):0;
		}
		
		override public function set x(value:Number):void 
		{
			super.x = value;
		}
		
		override public function get width():Number 
		{
			return elements[0]? Math.floor(elements[0].width):0;
		}
		
		override public function set width(value:Number):void 
		{
			super.width = value;
		}
		
	}

}