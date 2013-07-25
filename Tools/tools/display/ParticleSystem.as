package tools.display {
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import tools.pool.ObjectPool;
	import tools.utils.Marker;
	
	/**
	 * ...
	 * @author Egidijus
	 *
	 * Example:
	 *
	   var prt:ParticleSystem = new ParticleSystem(ParticleClass, 0.05);
	   addChild(prt);
	   Starling.juggler.add(prt);
	
	   prt.start();
	   prt.stop();
	   prt.emitterX = 20;
	   prt.emitterY = 20;
	 */
	
	public class ParticleSystem extends Sprite implements IAnimatable {
		public var started:Boolean = false;
		private var tempParticle:*;
		private var objectClass:Class;
		private var _interval:Number = 0.1; // seconds
		private var timer:Number = 0.1; // seconds
		private var parentHolder:DisplayObjectContainer;
		private var _emitterY:Number = 0;
		private var _emitterX:Number = 0;
		private var params:Object;
		
		/**
		 *
		 * @param	objectClass particlu klase,
		 * @param	interval kas kiek laiko pridedamas naujas partiklas, sekundemis
		 * @param	parentHolder nenaudomas
		 */
		public function ParticleSystem(objectClass:Class, interval:Number, parentHolder:DisplayObjectContainer = null) {
			this.parentHolder = parentHolder;
			this.interval = interval;
			timer = interval;
			this.objectClass = objectClass;
			
			ObjectPool.instance.registerPool(objectClass, 100, true);
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
		
		public function get interval():Number {
			return _interval;
		}
		
		public function set interval(value:Number):void {
			_interval = value;
		}
		
		public function start():void {
			started = true;
		}
		
		public function stop():void {
			started = false;
		}
		
		/* INTERFACE starling.animation.IAnimatable */
		
		public function advanceTime(time:Number):void {
			for (var i:int = 0; i < numChildren; i++) {
				if (getChildAt(i) is objectClass) {
					objectClass(getChildAt(i)).update(time);
				}
			}
			
			if (started) {
				timer -= time;
				
				if (timer <= 0) {
					tempParticle = ObjectPool.instance.getObj(objectClass, params) as Particle;
					tempParticle.x = _emitterX;
					tempParticle.y = _emitterY;
					addChild(tempParticle);
					
					timer = interval;
				}
				
			}
		}
		
		public function setParams(params:Object):void {
			this.params = params;
		}
	
	}

}