package tools.utils 
{
	/**
	 * ...
	 * @author Egidijus
	 */
	public class DataUtil 
	{
		
		public function DataUtil() 
		{
			
		}
		
		
		public static function randomFromArray(array:Array):*{
			var id:int = Math.floor(Math.random() * (array.length - 0.001));
			return array[id];
		}
		
		
		
	}

}