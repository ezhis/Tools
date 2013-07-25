package com.pepiplay.log{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class LogPanel extends Sprite {
		private var __width:Number;
		private var __height:Number;
		public var textas:TextField;
		public var back:Sprite;
		private var format:TextFormat;
		
		public function LogPanel() {
			format = new TextFormat();
		}
		
		override public function get width():Number {
			return __width;
		}
		
		override public function set width(value:Number):void {
			__width = value;
			update();
		}
		
		override public function get height():Number {
			return __height;
		}
		
		override public function set height(value:Number):void {
			__height = value;
			update();
		}
		
		public function set fontSize(value:int):void {
			format.size = value;
		}
		
		private function update():void {
			textas.width = __width;
			textas.height = __height;
			back.width = __width;
			back.height = __height;
		}
		public function print(txt:String):void {
			textas.appendText(txt);

			while (textas.textHeight >__height){
				var txtAr:Array = textas.getRawText().split("\n");
				txtAr.shift();
				textas.text = txtAr.join("\n");
			}
			textas.setTextFormat(format);
		}
		
		public function setParams(params:Object):void {
			
		}
	}

}