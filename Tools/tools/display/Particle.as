package tools.display {
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import tools.pool.IPoolable;
	import tools.pool.ObjectPool;
	
	public class Particle extends Sprite implements IPoolable {
		private var _angle:Number;
		private var _speed:Number;
		
		private var _lifeTime:Number;
		
		private var _destroyed:Boolean;
		private var _emitterX:Number = 0;
		private var _emitterY:Number = 0;
		private var params:Object;
		
		public function Particle() {
			_destroyed = true;
			
			create()
			//renew();
		
		}
		
		public function create():void {
			/*var image:Image = new Image(Game.assets.getTexture("microbes/mic_red10001"));
			image.pivotX = image.width * 0.4;
			image.pivotY = image.height * 0.4;
			addChild(image);*/
		}
		
		public function update(timePassed:Number):void {
			// Making the particle move
			
			x += Math.cos(_angle) * _speed * timePassed;
			y += Math.sin(_angle) * _speed * timePassed;
			
			// Small easing to make movement look pretty
			_speed -= 120 * timePassed;
			
			// Taking care of lifetime and removal
			_lifeTime -= timePassed;
			
			if (_lifeTime <= 0) {
				parent.removeChild(this);
				
				ObjectPool.instance.returnObj(this);
			}
		}
		
		public function renew(params:Object = null):void {
			this.params = params;
			if (!_destroyed) {
				return;
			}
			
			_destroyed = false;
			
			_angle = Math.random() * Math.PI * 2;
			rotation = Math.random() * Math.PI * 2;
			
			_speed = 150; // Pixels per second
			
			_lifeTime = 1; // Miliseconds
		
		}
		
		public function destroy():void {
			if (_destroyed) {
				return;
			}
			
			_destroyed = true;
		}
		
		
		public function setParams(params:Object):void {
		
		}
		
		/* INTERFACE IPoolable */
		
		public function get angle():Number {
			return _angle;
		}
		
		public function set angle(value:Number):void {
			_angle = value;
		}
		
		public function get speed():Number {
			return _speed;
		}
		
		public function set speed(value:Number):void {
			_speed = value;
		}
		
		public function get lifeTime():Number {
			return _lifeTime;
		}
		
		public function set lifeTime(value:Number):void {
			_lifeTime = value;
		}
		
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		public function set destroyed(value:Boolean):void {
			_destroyed = value;
		}
		
		public function get emitterX():Number {
			return _emitterX;
		}
		
		public function set emitterX(value:Number):void {
			_emitterX = value;
		}
		
		public function get emitterY():Number {
			return _emitterY;
		}
		
		public function set emitterY(value:Number):void {
			_emitterY = value;
		}
		

	
	}

}