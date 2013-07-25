package tools.utils {
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class TransformUtil {
		static private var dragObject:DisplayObject;
		static private var moveState:Number;
		static private var localPos:Point;
		static private var objectName:String;
		static private var scale_dist:Number;
		static private var start_rotation:Number;
		static private var start_Scale:Number;
		
		static private var dragObjects:Vector.<DisplayObject>
		static private var pivotObjects:Vector.<DisplayObject>
		static private var instance:TransformUtil;
		static private var allowInstatiation:Boolean = true;
		static private var traceName:Boolean;
		static public var onUptade:Function;
		
		public function TransformUtil() {
			if (!allowInstatiation) {
				throw new Error("Error: Instantiation failed");
			} else {
				allowInstatiation = false;
			}
		}
		
		static private function init():void {
			if (!instance) {
				instance = new TransformUtil();
				dragObjects = new Vector.<DisplayObject>();
				pivotObjects = new Vector.<DisplayObject>();
				onUptade = function(dragObject:DisplayObject):void {
					trace((dragObject.name ? dragObject.name + ": " : "") + "{ x:", Math.round(dragObject.x * 100) / 100 + ", y:" + Math.round(dragObject.y * 100) / 100 + ", rotation:" + Math.round(dragObject.rotation * 100) / 100 + ", scale:" + Math.round(dragObject.scaleX * 100) / 100 + "}");
				};
			}
		}
		
		/**
		 * Objectas padaromas draginamu. nuspaudus SHIFT galima sukinėti, CTRL - scalinti
		 * @param	pDragObject
		 */
		static public function initTransform(pDragObject:DisplayObject, traceName:Boolean = false):void {
			DragUtil.traceName = traceName;
			init();
			
			// Patikrinam ar elementas dar nera pridėtas
			var id:int = dragObjects.indexOf(pDragObject);
			if (id > -1) {
				return;
			}
			dragObjects.push(pDragObject);
			pDragObject.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		
		static public function initPivotTransform(pDragObject:DisplayObject, traceName:Boolean = false):void {
			//DragUtil.traceName = traceName;
			init();
			
			// Patikrinam ar elementas dar nera pridėtas
			var id:int = pivotObjects.indexOf(pDragObject);
			if (id > -1) {
				return;
			}
			pivotObjects.push(pDragObject);
			pivotObjects.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		
		
		
		static public function stopTransform(pDragObject:DisplayObject):void {
			var id:int = dragObjects.indexOf(pDragObject);
			if (id == -1) {
				return;
			}
			dragObjects.splice(id, 1);
		}
		
		static public function stopPivotTransform(pDragObject:DisplayObject):void {
			var id:int = dragObjects.indexOf(pDragObject);
			if (id == -1) {
				return;
			}
			dragObjects.splice(id, 1);
		}
		
		static public function initTouchTrace(pDragObject:DisplayObject):void {
			init();
			pDragObject.addEventListener(TouchEvent.TOUCH, onTraceTouch);
		}
		
		static private function onTraceTouch(e:TouchEvent):void {
			var touch:Touch;
			var tousches:Vector.<Touch> = e.getTouches(e.currentTarget as DisplayObject);
			
			if (tousches.length == 0)
				return;
			touch = tousches[0];
			
			if (touch.phase == TouchPhase.BEGAN) {

				trace("╒═════ Touch ════════════════════════")
				var par:DisplayObject = e.target as DisplayObject;
				var add:String = "";
				
				var pref:String = "│";
				var sub:String = "";
				var id:int = 0
				while (par) {
					var cl:String = getQualifiedClassName(par).split("::")[1] + " → " + getQualifiedSuperclassName(par).split("::")[1];
					if (id > 0) {
						pref = "│";
						//sub = "└"
						sub = " "
					}
					
					trace(pref +add +sub, cl);
					
					add += "  ";
					par = par.parent;
					id ++;
				}
				trace("╘════════════════════════════════════")
			}
			//var tousches:Vector.<Touch> = e.getTouches(dragObject);
		}
		
		static private function onTouch(e:TouchEvent):void {
			var touch:Touch;
			dragObject = e.currentTarget as DisplayObject;
			var tousches:Vector.<Touch> = e.getTouches(dragObject);
			
			if (tousches.length == 0)
				return;
			
			touch = tousches[0];
			var newPos:Point = touch.getLocation(dragObject.parent);
			
			if (touch.phase == TouchPhase.BEGAN) {
				moveState = 1;
				localPos = touch.getLocation(dragObject.parent);
				localPos.x -= dragObject.x;
				localPos.y -= dragObject.y;
				
				var xxd:Number = newPos.x - dragObject.x;
				var yyd:Number = newPos.y - dragObject.y;
				scale_dist = Math.sqrt(xxd * xxd + yyd * yyd);
				start_Scale = dragObject.scaleX;
				
				start_rotation = Math.atan2(yyd, xxd) - dragObject.rotation;
			}
			
			if (touch.phase == TouchPhase.MOVED) {
				if (moveState == 1) {
					if (e.shiftKey) {
						var xx:Number = newPos.x - dragObject.x;
						var yy:Number = newPos.y - dragObject.y;
						dragObject.rotation = Math.atan2(yy, xx) - start_rotation;
						
					} else if (e.ctrlKey) {
						var xxs:Number = newPos.x - dragObject.x;
						var yys:Number = newPos.y - dragObject.y;
						var dist:Number = Math.sqrt(xxs * xxs + yys * yys);
						dragObject.scaleX = dragObject.scaleY = start_Scale * dist / scale_dist;
					} else {
						dragObject.x = newPos.x - localPos.x;
						dragObject.y = newPos.y - localPos.y;
						
					}
					
					onUptade(dragObject);
				}
			}
			
			if (touch.phase == TouchPhase.ENDED) {
				moveState = 0;
			}
		}
	
	}

}