package tools.utils {
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class TouchUtil {
		private static var register:Dictionary;
		private static var initialised:Boolean = false;
		static private var onTapHandler:Function;
		static private var instance:TouchUtil;
		
		
		public function TouchUtil() {
		
		}
		
		static private function init():void {
			if (!instance) {
				instance = new TouchUtil();
				register = new Dictionary();
			}
		}
		
		public static function addTap(displayObject:DisplayObject, onTapHandler:Function, onReleaseHandler:Function = null):void {
			init();
			
			var data:Object = {};
			data.name = displayObject.name;
			data.displayObject = displayObject;
			data.onTapHandler = onTapHandler;
			data.onReleaseHandler = onReleaseHandler;
			register[displayObject] = data;
			
			displayObject.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public static function removeTap(displayObject:DisplayObject):void {
			var obj:Object = register[displayObject]
			if (obj) {
				obj.displayObject.addEventListener(TouchEvent.TOUCH, onTouch);
				delete register[displayObject];
			}
		}
		
		private static function onTouch(e:TouchEvent):void {
			var touch:Touch;
			var dragObject:DisplayObject = e.currentTarget as DisplayObject;
			var tousches:Vector.<Touch> = e.getTouches(dragObject);
			
			if (tousches.length == 0)
				return;
			
			touch = tousches[0];
			var newPos:Point = touch.getLocation(dragObject.parent);
			
			if (touch.phase == TouchPhase.BEGAN) {
				
				var obj:Object = register[dragObject]
				if (obj) {
					obj.onTapHandler();
				}
			}
			
			if (touch.phase == TouchPhase.MOVED) {

			}
			
			if (touch.phase == TouchPhase.ENDED) {
				obj = register[dragObject];
				if (obj) {
					if (obj.onReleaseHandler)
						obj.onReleaseHandler();
				}
			}
		
		}
	}

}