package utils
{
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class NineSliceImage extends Sprite{
		
		private var _imagesLib:Dictionary = new Dictionary();
		private var _images:Vector.<Image>;
		private var _newWidth:uint = 0;
		private var _newHeight:uint = 0;
		
		/** 
		 * Class constructor
		 * @param pPieces the pieces you want to use. Expects a TextureAtlas with 9 textures, ordered as following: [TL, TM, TR, ML, MM, MR, BL, BM, BR]
		 * @param pID the ID you want to give to these pieces. This is handy for button states because this nineslice class caches and reuses previous 9 slice sets.
		 */ 
		public function NineSliceImage(pPieces:TextureAtlas, pID:String){
			setImages(pPieces, pID);
		}
		
		/** 
		 * Sets a new 9 slice image set
		 * @param pPieces the pieces you want to use. Expects a TextureAtlas with 9 textures, ordered as following: [TL, TM, TR, ML, MM, MR, BL, BM, BR]
		 * @param pID the ID you want to give to these pieces. This is handy for button states because this nineslice class caches and reuses previous 9 slice sets.
		 */ 
		public function setImages(pPieces:TextureAtlas, pID:String):void{
			
			_images = _imagesLib[pID];
			
			if(!_images){
				_images = new Vector.<Image>();
				var textures:Vector.<Texture> = pPieces.getTextures();
				for each(var texture:Texture in textures){
					var img:Image = new Image(texture);
					_images.push(img);
				}
				_imagesLib[pID] = _images;
			}
			
			for(var i:uint = 0; i < numChildren; i++){
				removeChildAt(i);
				i --;
			}
			for each(img in _images){
				addChildAt(img, 0);
			}
			
			
			_images[1].x = _images[0].width;
			_images[2].x = _images[0].width + _images[1].width;
			_images[4].x = _images[3].width;
			_images[5].x = _images[3].width + _images[4].width;
			_images[7].x = _images[6].width;
			_images[8].x = _images[6].width + _images[7].width;
			
			_images[3].y = _images[4].y = _images[5].y = _images[0].height;
			_images[6].y = _images[7].y = _images[8].y = _images[0].height + _images[3].height - 1;
			
			if(_newWidth != 0) updateWidth();
			if(_newHeight != 0) updateHeight();
		}
		
		/** 
		 * Sets the width
		 * @param pWidth the new width
		 */ 
		public function setWidth(pWidth:uint):void{ 
			_newWidth = pWidth;
			updateWidth();
			
		}
		/** 
		 * Sets the height
		 * @param pHeight the new height
		 */ 
		public function setHeight(pHeight:uint):void{
			_newHeight = pHeight;
			updateHeight();
		}
		
		
		private function updateWidth():void{
			var newWidth:uint = _newWidth - (_images[0].width + _images[2].width);
			_images[1].width = _images[4].width = _images[7].width = newWidth;
			_images[2].x = _images[5].x = _images[8].x = _images[0].width + _images[1].width;
		}
		private function updateHeight():void{
			var newHeight:uint = _newHeight - (_images[0].height + _images[6].height);
			_images[3].height = _images[4].height = _images[5].height = newHeight-1;
			_images[6].y = _images[7].y = _images[8].y = _images[0].height + _images[3].height - 1;
		}
		
		
		/** 
		 * @override
		 */ 
		public override function dispose():void{
			for each(var img:Image in _images){
				removeChild(img);
			}
			_images = null;
			_imagesLib = null;
			super.dispose();
		}
	}
}