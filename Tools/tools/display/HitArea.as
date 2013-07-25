package tools.display {
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class HitArea extends Sprite {
		private var _radius:Number = 100;
		private var image:Image;
		private var image_size:int = 100;
		public var title:String;
		
		[Embed(source = "hitarea.png")]
		private static var imageClass:Class;
		
		public function HitArea(title:String = "") {
			this.title = title;
		//	show();
		}
		
		public function show():void {
			if (image) return;
			image = new Image(Texture.fromBitmap(new imageClass(), false, false));
			addChild(image);

			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			
			/*var textF:TextField = new TextField(100, 20, title);
			textF.x = -50
			addChild(textF);*/

		}
		
		public function hit(point:Point ):Boolean {
			var dist:Number = Math.sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y));

			if (dist < ((image_size / 2) * scaleX )) {
				return true;
			} else {
				return false;
			}
		}
		
		public function globalHit(point:Point ):Boolean {
			return hit( this.parent.globalToLocal(point));
		}
		
		/**
		 * Skaiciuoja atstuma iki nuo tasko iki centro
		 * @param	point 
		 * @return
		 */
		public function distance(point:Point):Number {
			var dist:Number = Math.sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y));
			return dist;
		}
		
		/**
		 * Spindulys 
		 */
		public function get radius():Number {
			return _radius;
		}
		
		/**
		 * Spindulys 
		 */
		public function set radius(value:Number):void {
			_radius = value;
			//trace("set radius:", _radius)
			scaleX = scaleY = value * 2 / image_size;
		}
	
	}

}