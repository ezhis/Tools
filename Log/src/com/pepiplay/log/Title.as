package com.pepiplay.log 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class Title extends Sprite 
	{
		public var txt:TextField ;
		public var back:Sprite ;
		public function Title() 
		{
			txt.autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function set title(str:String):void {
			txt.text = str;
			back.width = txt.width +1;
			
		}
		
	}

}