package tools.pool {
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	public class ObjectPool {
		private static var _instance:ObjectPool;
		private static var _allowInstantiation:Boolean;
		
		private var _pools:Object;
		
		public static function get instance():ObjectPool {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new ObjectPool();
				_allowInstantiation = false;
			}
			
			return _instance;
		}
		
		public function ObjectPool() {
			if (!_allowInstantiation) {
				throw new Error("Trying to instantiate a Singleton!");
			}
			
			_pools = {};
		}
		public function purge():void {
			for ( var prop : String in _pools ) {
				_pools[prop].items = null;
				_pools[prop] = null;
			}
			_pools = { };
		}
		public function registerPool(objectClass:Class, size:uint = 1, isDynamic:Boolean = true):void {
			/*

			if (!(describeType(objectClass).factory.implementsInterface.(@type == "IPoolable").length() > 0)) {
				throw new Error("Can't pool something that doesn't implement IPoolable!");
				return;
			}*/
			
			var qualifiedName:String = getQualifiedClassName(objectClass);
			
			
			if (!_pools[qualifiedName]) {
				_pools[qualifiedName] = new PoolInfo(objectClass, size, isDynamic);
			}
		}
		
		public function getObj(objectClass:Class, params:Object = null):IPoolable {

			
			var qualifiedName:String = getQualifiedClassName(objectClass);
			
			if (!_pools[qualifiedName]) {
				throw new Error("Can't get an object from a pool that hasn't been registered!");
				return null;
			}
			
			var returnObj:IPoolable;
			
			if (PoolInfo(_pools[qualifiedName]).active == PoolInfo(_pools[qualifiedName]).size) {
				if (PoolInfo(_pools[qualifiedName]).isDynamic) {
					returnObj = new objectClass();

					PoolInfo(_pools[qualifiedName]).size++;
					PoolInfo(_pools[qualifiedName]).items.push(returnObj);
				} else {
					return null;
				}
			} else {
				returnObj = PoolInfo(_pools[qualifiedName]).items[PoolInfo(_pools[qualifiedName]).active];

			}
			/*if (params) {
				trace("seting:",params.speedScale)
			} else {
				trace("seting:",params)
			}*/
			
			returnObj.renew(params);
			PoolInfo(_pools[qualifiedName]).active++;
			
			return returnObj;
		}
		
		public function returnObj(obj:IPoolable):void {
			var qualifiedName:String = getQualifiedClassName(obj);
			
			if (!_pools[qualifiedName]) {
				throw new Error("Can't return an object from a pool that hasn't been registered!");
				return;
			}
			
			var objIndex:int = PoolInfo(_pools[qualifiedName]).items.indexOf(obj);
			
			if (objIndex >= 0) {
				if (!PoolInfo(_pools[qualifiedName]).isDynamic) {
					PoolInfo(_pools[qualifiedName]).items.fixed = false;
				}
				
				PoolInfo(_pools[qualifiedName]).items.splice(objIndex, 1);
				
				obj.destroy();
				
				PoolInfo(_pools[qualifiedName]).items.push(obj);
				
				if (!PoolInfo(_pools[qualifiedName]).isDynamic) {
					PoolInfo(_pools[qualifiedName]).items.fixed = true;
				}
				
				PoolInfo(_pools[qualifiedName]).active--;
			}
		}
	
	}

}
