package tools.utils {
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.utils.getNextPowerOfTwo;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class StarlingUtil {
		
		public function StarlingUtil() {
		
		}
		
		public static function copyAsBitmapData(sprite:DisplayObject):BitmapData {
			
			if (sprite == null) {
				return null;
			}
			
			var resultRect:Rectangle = new Rectangle();
			sprite.getBounds(sprite, resultRect);
			
			var context:Context3D = Starling.context;
			var scale:Number = Starling.contentScaleFactor;
			
			var nativeWidth:Number = Starling.current.stage.stageWidth;
			var nativeHeight:Number = Starling.current.stage.stageHeight;
			
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0, 0, nativeWidth, nativeHeight);
			support.applyBlendMode(true);
			
			if (sprite.parent) {
				support.transformMatrix(sprite.parent);
			}
			
			support.translateMatrix(-sprite.x + sprite.width / 2, -sprite.y + sprite.height / 2);
			
			var result:BitmapData = new BitmapData(nativeWidth, nativeHeight, true, 0x00000000);
			
			support.pushMatrix();
			
			support.blendMode = sprite.blendMode;
			support.transformMatrix(sprite);
			sprite.render(support, 1.0);
			support.popMatrix();
			
			support.finishQuadBatch();
			
			context.drawToBitmapData(result);
			
			var w:Number = sprite.width;
			var h:Number = sprite.height;
			
			if (w == 0 || h == 0) {
				return null;
			}
			
			var returnBMPD:BitmapData = new BitmapData(w, h, true, 0);
			var cropArea:Rectangle = new Rectangle(0, 0, sprite.width, sprite.height);
			
			returnBMPD.draw(result, null, null, null, cropArea, true);
			return returnBMPD;
		}
		
		public static function copyAsBitmapData2(displayObject:DisplayObject, transparentBackground:Boolean = false, backgroundColor:uint = 0xcccccc):BitmapData {
			var resultRect:Rectangle = new Rectangle();
			displayObject.getBounds(displayObject, resultRect);
			var result:BitmapData = new BitmapData(displayObject.width * 1.5, displayObject.height * 1.5, transparentBackground, backgroundColor);
			
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0, 0, displayObject.width, displayObject.height);
			support.applyBlendMode(true);
			
			support.transformMatrix(displayObject);
			//support.translateMatrix( -resultRect.x, -resultRect.y );
			support.pushMatrix();
			displayObject.render(support, 1.0);
			support.popMatrix();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			
			//var croppedRes:BitmapData = new BitmapData(displayObject.width, displayObject.height);
			//croppedRes.copyPixels(result, resultRect, new Point(0,0));
			
			return result;
		}
		

		
		public static function copyAsBitmapData4(displayObject:starling.display.DisplayObject, transparentBackground:Boolean = true, backgroundColor:uint = 0xcccccc):BitmapData {
			if (displayObject == null || isNaN(displayObject.width) || isNaN(displayObject.height))
				return null;
				
			var resultRect:Rectangle = new Rectangle();
			displayObject.getBounds(displayObject, resultRect);
			
			var context:Context3D = Starling.context;
			var scale:Number = Starling.contentScaleFactor;
			var nativeWidth:Number = getNextPowerOfTwo(Starling.current.stage.stageWidth * scale);
			var nativeHeight:Number = getNextPowerOfTwo(Starling.current.stage.stageHeight * scale);
			
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			
			var result:BitmapData = new BitmapData(displayObject.width, displayObject.height, transparentBackground, backgroundColor);
			
			
			
			support.setOrthographicProjection(0, 0, Starling.current.stage.stageWidth/ scale, Starling.current.stage.stageHeight/ scale);
			support.applyBlendMode(true);
			support.translateMatrix(-resultRect.x, -resultRect.y);
			support.pushMatrix();
			//support.pushBlendMode();
			support.blendMode = displayObject.blendMode;
			displayObject.render(support, 1.0);
			support.popMatrix();
			//support.popBlendMode();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
		}
		
		public static function copyAsBitmapData5(sprite:starling.display.DisplayObject):BitmapData {
			if (sprite == null)
				return null;
			
			var resultRect:Rectangle = new Rectangle();
			sprite.getBounds(sprite, resultRect);
			
			var context:Context3D = Starling.context;
			var scale:Number = Starling.contentScaleFactor;
			var nativeWidth:Number = getNextPowerOfTwo(Starling.current.stage.stageWidth * scale);
			var nativeHeight:Number = getNextPowerOfTwo(Starling.current.stage.stageHeight * scale);
			
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0, 0, nativeWidth / scale, nativeHeight / scale);
			support.applyBlendMode(true);
			support.transformMatrix(sprite.root);
			support.translateMatrix(-resultRect.x, -resultRect.y);
			
			var result:BitmapData = new BitmapData(resultRect.width * scale, resultRect.height * scale, true, 0x00000000);
			
			support.pushMatrix();
			// support.pushBlendMode();
			
			support.blendMode = sprite.blendMode;
			support.transformMatrix(sprite);
			sprite.render(support, 1.0);
			support.popMatrix();
			// support.popBlendMode();
			
			support.finishQuadBatch();
			
			context.drawToBitmapData(result);
			
			return result;
		}
		public static function copyAsBitmapData3(displayObject:DisplayObject, transparentBackground:Boolean = false, backgroundColor:uint = 0xcccccc):BitmapData {
			var resultRect:Rectangle = new Rectangle();
			displayObject.getBounds(displayObject, resultRect);
			var result:BitmapData = new BitmapData(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, transparentBackground, backgroundColor);
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0, 0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			support.applyBlendMode(true);
			
			support.translateMatrix(-resultRect.x, -resultRect.y);
			support.pushMatrix();
			support.blendMode = displayObject.blendMode;
			displayObject.render(support, 1.0);
			support.popMatrix();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			
			var croppedRes:BitmapData = new BitmapData(displayObject.width, displayObject.height, transparentBackground, backgroundColor);
			croppedRes.copyPixels(result, resultRect, new Point(0, 0));
			
			return croppedRes;
		}
	}

}