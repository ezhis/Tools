package tools.display {
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import tools.utils.Marker;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class EImage extends Sprite {
		private var marker:Marker;
		private var showPivot:Boolean;
		
		public function EImage(texture:Texture, showPivot:Boolean = false) {
			this.showPivot = showPivot;
			var image:Image = new Image(texture);
			addChild(image);
			
			marker = new Marker();
			if (showPivot) {
				addChild(marker);
			}
		
		}
		
		override public function get pivotX():Number {
			return super.pivotX;
		
		}
		
		override public function set pivotX(value:Number):void {
			super.pivotX = value;
			marker.x = value;
		
		}
		
		override public function get pivotY():Number {
			return super.pivotY;
		}
		
		override public function set pivotY(value:Number):void {
			super.pivotY = value;
			marker.y = value;
		}
	
	}

}