package tools.utils {
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Egidijus Ambražas
	 */
	public class ScreenUtil {
		
		public function ScreenUtil() {
		
		}
		
		public static function zoomStretch(stageWidth:Number, stageHeight:Number, stage:Stage):Number {
			var tr:Number = stageHeight / stageWidth;
			var rt:Number = stageWidth / stageHeight;
			
			var screenWidth:Number = stage.fullScreenWidth;
			var screenHeight:Number = stage.fullScreenHeight;
			var scale:Number = 1;
			if (screenHeight / screenWidth < tr) {
				Starling.current.stage.stageHeight = stageHeight;
				Starling.current.stage.stageWidth = stageWidth * (screenWidth / screenHeight) / rt;
				
				scale =  Starling.current.stage.stageWidth/screenWidth;
			} else {
				Starling.current.stage.stageWidth = stageWidth;
				Starling.current.stage.stageHeight = stageHeight * (screenHeight / screenWidth) * rt;
				
				scale =  Starling.current.stage.stageHeight/screenHeight;
			}
			
			return scale;
			
			
			
			//Strace("stage::", Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
		}
		
		public static function getLetterbox(stageWidt:Number, stageHeight:Number, stage:Stage):Rectangle {
			var ASPECT_RATIO:Number = stageHeight / stageWidt;
			
			var screenWidth:int = stage.stageWidth;
			var screenHeight:int = stage.stageHeight;
			
			var viewPort:Rectangle = new Rectangle();
			if (screenHeight / screenWidth < ASPECT_RATIO) {
				viewPort.height = screenHeight;
				viewPort.width = int(viewPort.height / ASPECT_RATIO);
				viewPort.x = int((screenWidth - viewPort.width) / 2);
			} else {
				viewPort.width = screenWidth;
				viewPort.height = int(viewPort.width * ASPECT_RATIO);
				viewPort.y = int((screenHeight - viewPort.height) / 2);
			}
			return viewPort;
		}
	}

}