package tools {
	import flash.utils.clearInterval;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Time {
		static private var _instance:Time;
		static private var _allowInstance:Boolean = true;
		static private var functions:Vector.<Object>
		
		public function Time() {
		
		}
		
		/*public static function getInstance():Time {
		   if (_instance == null) {
		   _allowInstance = true;
		   _instance = new Time();
		   _allowInstance = false;
		
		   functions = new Dictionary();
		   }
		
		   return _instance;
		 }*/
		
		static private function init():void {
			if (_allowInstance) {
				_allowInstance = false;
				
				functions = new Vector.<Object>;
			}
		}
		
		/**
		 * funkcija iskvieciama po nurodyto laiko
		 * @param	functionName funkcija
		 * @param	delay uzdelsimas sekundemis
		 * @param	args papildomi argumentai
		 */
		public static function delay(functionName:Function, delay:Number, ... args):void {
			init();
			
			//trace("**", functionName, (args as Array).length)
			if ((args as Array).length > 0) {
				var id:int = setTimeout(functionName, delay * 1000, args);
			} else {
				id = setTimeout(functionName, delay * 1000);
			}
			
			//	functions[functionName] = id;
			
			functions.push({func: functionName, id: id});
		}
		
		/**
		 * sustabdomi visi uzdelsimai
		 */
		public static function clearAllDelays():void {
			if (!functions)
				return;
			
			for (var i:int = 0; i < functions.length; i++) {
				
				clearInterval(functions[i].id)
					//	return;
				
			}
			functions = new Vector.<Object>;
		}
		
		static public function clearDelay(function_name:Function):void {
			if (!functions)
				return;
			
			for (var i:int = 0; i < functions.length; i++) {
				
				if (functions[i].func == function_name) {
					clearInterval(functions[i].id)
					functions.splice(i, 1);
					return;
				}
			}
		
		}
		
		static public function get time():int {
			return (new Date()).time;
		}
	}

}