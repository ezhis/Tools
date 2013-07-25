package tools.utils {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class DebugDraw {
		static private var _scale:Number;
		static private var _stage:Stage;
		static private var instance:DebugDraw;
		static private var drawObjects:Vector.<Object>;
		private var allowInstatiation:Boolean = true;
		
		[Embed(source="DebugDrawAssets.swf", symbol="Over")]
		static private var OverClass:Class;
		static private var len:int = 0;
		static private var debugWindow:Shape;
		static private var interval:uint;
		
		public function DebugDraw() {
			if (!allowInstatiation) {
				throw new Error("Error: Instantiation failed");
			} else {
				allowInstatiation = false;
			}
		}
		
		static private function init():void {
			if (!instance) {
				instance = new DebugDraw();
				drawObjects = new Vector.<Object>();
				interval = setInterval(update, 20);
			}
		}
		
		static public function setup(stage:Stage, scale:Number):void {
			_scale = scale;
			_stage = stage;
			debugWindow = new Shape();
			_stage.addChild(debugWindow);
		}
		static public function showPoint(point:*, parent:DisplayObjectContainer):void {
			init();
			if (!_stage)
				throw new Error("Error: Stage not found");
			drawObjects.push({isPoint:true, object: point, parent:parent});
			len = drawObjects.length;
		}
		
		static public function showPivotPoint(displayObject:DisplayObject):void {
			init();
			if (!_stage)
				throw new Error("Error: Stage not found");
			drawObjects.push({isPoint:false, object: displayObject, drawPivot: true});
			len = drawObjects.length;
		}
		
		
		static public function showBounds(displayObject:DisplayObject):void {
			init();
			if (!_stage)
				throw new Error("Error: Stage not found");
			drawObjects.push({isPoint:false, object: displayObject, drawBounds: true});
			len = drawObjects.length;
		}
		
		static public function removePivotPoint(displayObject:DisplayObject):void {
			var dsp:DisplayObject
			for (var i:int = 0; i < len; i++) {
				dsp = drawObjects[i].object;
				if (displayObject == dsp) {
					drawObjects[i].drawPivot = false;
				}
			}
		}
		
		static private function update():void {
			debugWindow.graphics.clear();
			var dsp:DisplayObject
			for (var i:int = 0; i < len; i++) {
				dsp = drawObjects[i].object;
				
				if(!drawObjects[i].isPoint){
					if (dsp.stage) {
						if (drawObjects[i].drawPivot) {
							var pp:Point = new Point(dsp.pivotX, dsp.pivotY);
							pp = dsp.localToGlobal(pp);
							drawPivot(pp);
						}
						if (drawObjects[i].drawBounds) {
							var rec:Rectangle = dsp.getBounds(dsp.stage);
							drawRec(rec);
						}
					}
				} else {
					//if(dsp.parent){
						pp = new Point(dsp.x, dsp.y);
						pp = drawObjects[i].parent.localToGlobal(pp);
						drawPoint(pp);
					//}
				}
			}
		}
		
		static private function drawRec(rec:Rectangle):void {
			debugWindow.graphics.lineStyle(1, 0xFF0000, 1);
			debugWindow.graphics.beginFill(0x000000, 0.0);
			debugWindow.graphics.drawRect(rec.x / _scale, rec.y / _scale, rec.width / _scale, rec.height / _scale);
			debugWindow.graphics.endFill();
			
		//	var over:Sprite = new OverClass();
		//	over.width = 
		}
		
		static private function drawPivot(pp:Point):void {
			debugWindow.graphics.lineStyle(1, 0x808080, 1);
			debugWindow.graphics.beginFill(0xFFFFFF, 0.5);
			debugWindow.graphics.drawCircle(pp.x / _scale, pp.y / _scale, 6);
			debugWindow.graphics.endFill();
			
			debugWindow.graphics.lineStyle(1, 0x000000, 1);
			debugWindow.graphics.beginFill(0xFFFFFF, 1);
			debugWindow.graphics.drawCircle(pp.x / _scale, pp.y / _scale, 3);
			debugWindow.graphics.endFill();
		}
		
		static private function drawPoint(pp:Point):void {
			debugWindow.graphics.lineStyle(1, 0x000000, 1);
			debugWindow.graphics.moveTo(pp.x / _scale,  pp.y / _scale - 4); 
			debugWindow.graphics.lineTo(pp.x / _scale,  pp.y / _scale + 4);
			
			debugWindow.graphics.moveTo(pp.x / _scale-4,  pp.y / _scale); 
			debugWindow.graphics.lineTo(pp.x / _scale+4,  pp.y / _scale);
			
			debugWindow.graphics.beginFill(0xFFFFFF, 1);
			debugWindow.graphics.drawCircle(pp.x / _scale, pp.y / _scale, 3);
			debugWindow.graphics.endFill();
			
			
		}
	}

}
