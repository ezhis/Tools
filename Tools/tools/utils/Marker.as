package tools.utils 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class Marker extends Sprite 
	{
		[Embed(source = "newMarker.png")]
		private static var imageClass:Class;
		
		public function Marker(_x:Number = 0, _y:Number = 0 ) 
		{
			var image:Image = new Image(Texture.fromBitmap(new imageClass(), false, false));
			addChild(image);
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			image.scaleX = image.scaleY = 0.7;
			x = _x;
			y = _y;
		}
		
	}

}