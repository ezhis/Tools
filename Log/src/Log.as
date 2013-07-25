package {
	import com.pepiplay.log.LogPanel;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class Log extends Sprite {
		private static var _instance:Log;
		private static var _allowInstantiation:Boolean;
		private static var _stage:Stage;
		private static var _logPanel:LogPanel;
		private static var _visible:Boolean = true;
		
		public function Log() {
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed");
			}
		}
		
		public static function init(pStage:Stage, pView:Rectangle = null, pFontSize:int = 8):void {
			if (!pView) {
				pView = new Rectangle(0, 0, 200, 200);
			}
			_stage = pStage;
			
			if (_instance == null) {
				_allowInstantiation = true;
				_instance = new Log();
				_allowInstantiation = false;
			}
			
			_logPanel = new LogPanel();
			_stage.addChild(_logPanel);
			_logPanel.x = pView.x;
			_logPanel.y = pView.y;
			_logPanel.width = pView.width;
			_logPanel.height = pView.height;
			_logPanel.fontSize = pFontSize;
			
		}
		
		/**
		 *
		 * @param	params
		 */
		public static function setParams(params:Object):void {
			_logPanel.setParams(params);
		}
		
		public static function print(... args):void {
			if (!_logPanel) {
				throw new Error("Error: Log not initialized. Add Log.init(stage);");
			}
			
			var txt:String = "";
			for (var i:int = 0; i < args.length; ++i) {
				txt += args[i] + " ";
			}
			txt += "\n";
			
			_logPanel.print(txt);
		}
		
		static public function get visible():Boolean {
			return _visible;
		}
		
		static public function set visible(value:Boolean):void {
			_visible = value;
			_logPanel.visible = value;
		}
		
		
	
	}

}