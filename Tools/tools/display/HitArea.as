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
			//image.alpha = 0;
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			
			/*var textF:TextField = new TextField(100, 20, title);
			textF.x = -50
			addChild(textF);*/
			
			//TransformLog.setArea(this);
			
			//			trace("set show radius:", _radius)
		}
		
		public function hit(point:Point ):Boolean {
			
			//return false;
			var dist:Number = Math.sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y));
			//trace("dist:", dist);
			//if (dist < _radius) {
			if (dist < ((image_size / 2) * scaleX )) {
				return true;
			} else {
				return false;
			}
			
			
		//	if(image) image.scaleX = image.scaleY = 
		}
		
		public function globalHit(point:Point ):Boolean {
			return hit( this.parent.globalToLocal(point));
		}
		
		public function distance(point:Point):Number {
			var dist:Number = Math.sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y));
			return dist;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
			trace("set radius:", _radius)
			scaleX = scaleY = value * 2 / image_size;
		}
	
	}

}