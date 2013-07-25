package {
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	
	public function setParams(displayObject:DisplayObject, params:Object):void {
        for ( var prop : String in params ){
			displayObject[prop] = params[prop];
        }
	}

}