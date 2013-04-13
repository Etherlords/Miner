package view.components 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	
	/**
	 * ...
	 * @author Nikro
	 */
	public class ClockIcon extends Sprite 
	{
		private var bgTex:Texture;
		private var arrowTex:Texture;
		private var arrow:Image;
		private var arrowContainer:Sprite;
		
		public function ClockIcon(bg:Texture, arrow:Texture) 
		{
			super();
			this.arrowTex = arrow;
			this.bgTex = bg;
			
			initilzie();
			
		}
		
		private function initilzie():void 
		{
			var back:Image = new Image(bgTex);
			arrow = new Image(Texture.fromColor(bgTex.width / 2, 4, 0xAAFFFFFF));
			arrow.smoothing = TextureSmoothing.TRILINEAR;
			arrowContainer = new Sprite();
			arrowContainer.addChild(arrow);
			
			
			addChild(back);
			addChild(arrowContainer);
			
			//arrow.x = -arrow.width/2
			arrow.y = -arrow.height / 2;
			
			arrowContainer.x = bgTex.width / 2;
			arrowContainer.y = bgTex.height / 2;
		}
		
		public function set time(value:Number):void
		{
			var rotation:Number = value / 10 * 360 - 90;
			arrowContainer.rotation = deg2rad(rotation);
			
		}
		
	}

}