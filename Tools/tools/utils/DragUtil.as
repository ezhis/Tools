package tools.utils {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.setInterval;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
//	import starling.extensions.Scale9Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class DragUtil {
		static private var dragObject:DisplayObject;
		static private var moveState:Number;
		static private var localPos:Point;
		static private var objectName:String;
		static private var scale_dist:Number;
		static private var start_rotation:Number;
		static private var start_Scale:Number;
		
		static private var dragObjects:Vector.<DisplayObject>
		static private var pivotObjects:Vector.<DisplayObject>
		static private var instance:DragUtil;
		static private var allowInstatiation:Boolean = true;
		static private var traceName:Boolean;
		static public var onUptade:Function;
		
		[Embed(source="newMarker.png")]
		private static var NewMarkerImage:Class;
		
		[Embed(source = "pivot.png")]
		private static var PivotPointImage:Class;
		
		[Embed(source = "borders.png")]
		private static var BordersImage:Class;
		
		static private var pivotPoint:Image;
//		static private var borders:Scale9Image;
		static private var showPivotPoint:Boolean;
		static private var pivotLocalPos:Point;
		static private var isDraging:Boolean = false;
		static private var pivotDragObject:Sprite;
		
		public function DragUtil() {
			if (!allowInstatiation) {
				throw new Error("Error: Instantiation failed");
			} else {
				allowInstatiation = false;
			}
		}
		
		static private function init():void {
			if (!instance) {
				instance = new DragUtil();
				dragObjects = new Vector.<DisplayObject>();
				pivotObjects = new Vector.<DisplayObject>();
				onUptade = function(dragObject:DisplayObject):void {
					trace((dragObject.name ? dragObject.name + ": " : "") + "{ x:", Math.round(dragObject.x * 100) / 100 + ", y:" + Math.round(dragObject.y * 100) / 100 + ", rotation:" + Math.round(dragObject.rotation * 100) / 100 + ", scaleX:" + Math.round(dragObject.scaleX * 100) / 100+ ", scaleY:" + Math.round(dragObject.scaleY * 100) / 100 + "}");
				};
				pivotPoint = new Image(Texture.fromBitmap(new PivotPointImage(), false, false));
				pivotPoint.pivotX = pivotPoint.pivotY = pivotPoint.width / 2;
				pivotPoint.scaleX = pivotPoint.scaleY = 0.4;
				
			}
		}
		
		/**
		 * Objectas padaromas draginamu. nuspaudus SHIFT galima sukinėti, CTRL - scalinti
		 * @param	pDragObject
		 */
		static public function initDrag(pDragObject:DisplayObject, traceName:Boolean = false):void {
			DragUtil.traceName = traceName;
			init();
			
			// Patikrinam ar elementas dar nera pridėtas
			var id:int = dragObjects.indexOf(pDragObject);
			if (id > -1) {
				return;
			} else {
				
			}
			dragObjects.push(pDragObject);
			pDragObject.touchable = true;
			pDragObject.addEventListener(TouchEvent.TOUCH, onTouch);
			

		}
		
		static public function stopDrag(pDragObject:DisplayObject):void {
			var id:int = dragObjects.indexOf(pDragObject);
			if (id == -1) {
				return;
			}
			dragObjects.splice(id, 1);
		}
		
		
		/**
		 */
		static public function initPivotDrag(pivotDragObject:Sprite, traceName:Boolean = false):void {
			DragUtil.pivotDragObject = pivotDragObject;
			//DragUtil.traceName = traceName;
			init();
			
			// Patikrinam ar elementas dar nera pridėtas
			/*var id:int = pivotObjects.indexOf(pDragObject);
			if (id > -1) {
				return;
			}*/
			
			//pivotObjects.addEventListener(TouchEvent.TOUCH, onTouch);
			//trace("update pivot")
			//updatePP(pDragObject);
			setInterval(updatePivot, 40, pivotDragObject);
			pivotPoint.addEventListener(TouchEvent.TOUCH, onPivotTouch);
			
			/*var marker_image__:Image = new Image(Texture.fromBitmap(new NewMarkerImage(), false, false));
			marker_image__.name = "marker_image__";
			marker_image__.pivotX = marker_image__.width / 2;
			marker_image__.pivotY = marker_image__.height / 2;
			
			var spr:Sprite = pDragObject as Sprite;
			if (spr) {
				spr.addChild(marker_image__);
				marker_image__.x = spr.pivotX;
				marker_image__.y = spr.pivotY;
				
				pivotObjects.push(pDragObject);
			}*/
		}
		
		static private function updatePivot(disp:DisplayObject):void 
		{
			if (!isDraging) {
				updatePP(disp);
			}
		}
		
		static private function onPivotTouch(e:TouchEvent):void {
			var touch:Touch;
			
			dragObject = e.currentTarget as DisplayObject;
			var tousches:Vector.<Touch> = e.getTouches(dragObject);
			
			if (tousches.length == 0)
				return;
			
			touch = tousches[0];
			var newPos:Point = touch.getLocation(dragObject.parent);
			
			if (touch.phase == TouchPhase.BEGAN) {
				isDraging = true;
				pivotLocalPos = touch.getLocation(dragObject.parent);
				pivotLocalPos.x -= dragObject.x;
				pivotLocalPos.y -= dragObject.y;
			}
			
			if (touch.phase == TouchPhase.MOVED) {
				dragObject.x = newPos.x - pivotLocalPos.x;
				dragObject.y = newPos.y - pivotLocalPos.y;
				
				var pp:Point = pivotDragObject.globalToLocal(new Point(dragObject.x, dragObject.y));
				trace("{ pivotX:", Math.round(pp.x * 100) / 100 + ", pivotY:" + Math.round(pp.y * 100) / 100 + "}");
			}
			
			if (touch.phase == TouchPhase.ENDED) {
				isDraging = false; 
				
				
				pp = pivotDragObject.globalToLocal(new Point(dragObject.x, dragObject.y));
				var difx:Number = pp.x -pivotDragObject.pivotX;
				var dify:Number = pp.y -pivotDragObject.pivotY;
				
				pivotDragObject.pivotX = pp.x;
				pivotDragObject.pivotY = pp.y;
				pivotDragObject.x += difx;
				pivotDragObject.y += dify;
	
			}
		}
		
		static public function stopPivotDrag(pDragObject:DisplayObject):void {
			var id:int = pivotObjects.indexOf(pDragObject);
			if (id == -1) {
				return;
			}
			pivotObjects.splice(id, 1);
		}
		
		
		
		static public function initTouchTrace(pDragObject:DisplayObject, showPivotPoint:Boolean = false):void {
			DragUtil.showPivotPoint = showPivotPoint;
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
				updatePP(par);
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
			
			//TransformLog.setPoint(touch.globalX, touch.globalY);
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
				onUptade(dragObject);
				updatePP(dragObject);

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
					updatePP(dragObject);
				}
			}
			
			if (touch.phase == TouchPhase.ENDED) {
				moveState = 0;
				//Starling.current.stage.removeChild(pivotPoint);
				//Starling.current.stage.removeChild(borders);
				TransformLog.hidePoint();
			}
		}
		
		static private function updatePP(dragObject:DisplayObject):void {
			//Starling.current.stage.addChild(pivotPoint);
			var pp:Point = dragObject.localToGlobal(new Point(dragObject.pivotX, dragObject.pivotY));
			pivotPoint.x = pp.x;
			pivotPoint.y = pp.y;
			
			TransformLog.setPoint(pivotPoint.x, pivotPoint.y);
			
			//Starling.current.stage.addChild(borders);
			//borders.x = pp.x;
			//borders.y = pp.y;
			
			//var rec:Rectangle = dragObject.getBounds(Starling.current.stage);
			//TransformLog.showBounds(rec);
			
			/*borders.x = rec.x;
			borders.y = rec.y;
			borders.width = rec.width;
			borders.height = rec.height;*/
			
		}
	
	}

}