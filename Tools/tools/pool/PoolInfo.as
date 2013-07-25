package tools.pool {
	
	public class PoolInfo {
		public var items:Vector.<IPoolable>;
		public var itemClass:Class;
		public var size:uint;
		public var active:uint;
		public var isDynamic:Boolean;
		
		public function PoolInfo(itemClass:Class, size:uint, isDynamic:Boolean = true) {
			this.itemClass = itemClass;
			items = new Vector.<IPoolable>(size, !isDynamic);
			this.size = size;
			this.isDynamic = isDynamic;
			active = 0;
			
			initialize();
		}
		
		private function initialize():void {
			for (var i:int = 0; i < size; i++) {
				items[i] = new itemClass();
			}
		}
	}
}