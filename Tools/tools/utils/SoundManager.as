package tools.utils {
	import com.pepiplay.utils.AssetManager;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import tools.Time;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class SoundManager {
		static private var playingSounds:Dictionary = new Dictionary();
		static private var allSounds:Dictionary = new Dictionary();
		
		static private var assets:AssetManager;
		static private var allowInstatiation:Boolean = true;
		static private var instance:SoundManager;
		
		public function SoundManager() {
			if (!allowInstatiation) {
				throw new Error("Error: Instantiation failed");
			} else {
				allowInstatiation = false;
			}
		}
		
		static public function init(assets:AssetManager):void {
			if (!instance) {
				SoundManager.assets = assets;
			} 
		}
		
		static public function startLoop(sound_name:String, level:Number = 1, group:String = "sound"):void {
			
			var sound:Object;
			if (allSounds[sound_name]) {
				sound = allSounds[sound_name];
				if (sound.playing)
					return;
				sound.playing = true;
				sound.chanel = assets.playSound(sound_name, 0, int.MAX_VALUE, new SoundTransform(level) );
			} else {
				sound = {};
				sound.name = sound_name;
				sound.group = group;
				sound.playing = true;
				sound.chanel = assets.playSound(sound_name, 0, int.MAX_VALUE, new SoundTransform(level));
				allSounds[sound_name] = sound;
			}
		}
		
		static public function playSound(sound_name:String, level:Number = 1, delay:Number = 0):void {
			if (delay > 0) {
				Time.delay(assets.playSound, delay, [sound_name]);
			} else {
				var ch:SoundChannel = assets.playSound(sound_name);
				if (!ch) {
					throw new Error( "WARNING: sound '" + sound_name + "' not found, suported only mp3 files" )
				}
			}
		}
		
		static public function stopLoop(sound_name:String):void {
			var sound:Object;
			if (allSounds[sound_name]) {
				sound = allSounds[sound_name];
				if (!sound.playing)
					return;
				sound.playing = false;
				(sound.chanel as SoundChannel).stop();
			}
		}
		
		static public function stopAllLoops(group:String = "sound"):void {
			var sound:Object;
			for (var sound_name:String in allSounds) {
				sound = allSounds[sound_name];
				if (sound.group == group) {
					if (sound.playing) {
						sound.playing = false;
						(sound.chanel as SoundChannel).stop();
					}
				}
			}
		}
		
		
		static public function setVolume(sound_name:String, volume:Number = 1):void {
			var sound:Object;
			if (allSounds[sound_name]) {
				sound = allSounds[sound_name];
				if (!sound.playing)
					return;
					
				(sound.chanel as SoundChannel).soundTransform = new SoundTransform(volume);
			}
		}
		
		
/*		public function playSingleSound(sound_name:String):void {
			
			var sound:Object;
			if (allSounds[sound_name]) {
				sound = allSounds[sound_name];
				if (sound.playing)
					return;
				
			} else {
				sound = {};
				sound.name = sound_name;
				allSounds[sound_name] = sound;
					//SoundManager.getInstance().play(sound_name, 0, 0, int.MAX_VALUE);
					//
			}
			//trace("start sound", sound_name)
			
			sound.playing = true;
			var sound_len:Number = assets.getSound(sound_name).length / 1000;
			assets.playSound(sound_name);
			Time.delay(soundEnded, sound_len, [sound_name]);
		
		}*/
		
/*		private function soundEnded(sound_name:String):void {
			//throw new Error("soundEnded");
			//playingSounds[sound_name] = false;
			allSounds[sound_name].playing = false;
		}
		
		public function stopSounds():void {
			
			for (var sound_name:String in allSounds) {
				var value:Object = allSounds[sound_name];
				value.playing = false;
				SoundManager.getInstance().stopSfx(sound_name);
					// do stuff
			}
		

		}*/
	}

}