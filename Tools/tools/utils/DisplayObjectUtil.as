package tools.utils 
{
	import flash.geom.Matrix;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Egidijus
	 */
	public class DisplayObjectUtil 
	{
		
		public function DisplayObjectUtil() 
		{
			
		}
		
		public static function changeParent(child:DisplayObject, parent:DisplayObjectContainer):void {
			var parentMatrix:Matrix = child.getTransformationMatrix(parent)
			child.transformationMatrix = parentMatrix;
			parent.addChild(child);
			
		}
		
		
		
	}

}