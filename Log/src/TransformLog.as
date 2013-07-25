package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Egidijus
	 */
	public class TransformLog extends Sprite {
		
		private static var _instance:TransformLog;
		private static var _allowInstantiation:Boolean;
		static private var _starlingVieport:Rectangle;
		static private var _stage:Stage;
		static private var stageScale:Number;
		static private var pivot2:MovieClip;
		static private var borders:Sprite;
		
		
		private static var areasList:Vector.<Object>;
		
		public function TransformLog() {
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed");
			}
		}
		
		public static function init(pStage:Stage, starlingVieport:Rectangle, stageScale:Number):void {
			TransformLog.stageScale = stageScale;
			_starlingVieport = starlingVieport;
			_stage = pStage;
			
			if (_instance == null) {
				_allowInstantiation = true;
				_instance = new TransformLog();
				_allowInstantiation = false;
			}
			
			//var pivot:MovieClip = new Pivot();
		//	_stage.addChild(pivot);
		//	
			pivot2 = new Pivot();
			_stage.addChild(pivot2);
			pivot2.x = starlingVieport.width / stageScale;
			pivot2.visible = false;
			
			borders = new Borders();
			_stage.addChild(borders);
			borders.visible = false;
			
			areasList = new Vector.<Object>;
			
			var inteval:int = setInterval(update, 40);
		}
		
		static private function update():void {
			for (var i:int = 0; i < areasList.length; i++) 	{
				var pp:Point = areasList[i].obj.parent.localToGlobal(new Point(areasList[i].obj.x, areasList[i].obj.y));
				
				
				var area:MovieClip = areasList[i].area;
				
				var parentMatrix:Matrix = areasList[i].obj.getTransformationMatrix(areasList[i].obj.stage)
				area.area.transform.matrix =  parentMatrix;
				area.area.x = 0;
				area.area.y = 0;
				
				area.x = pp.x/ stageScale;
				area.y = pp.y / stageScale;
				area.area.scaleX = area.area.scaleY = area.area.scaleX /stageScale;
				
				
				
//area.area.width = area.area.height =  areasList[i].obj.radius * 2 // stageScale;



			}
		}
		
		public static function setPoint(xx:Number, yy:Number):void {
			pivot2.x = xx / stageScale;
			pivot2.y = yy / stageScale;
			pivot2.visible = true;
		}
		
		public static function setArea(obj:*):void {
			for (var i:int = 0; i < areasList.length; i++) 
			{
				if (areasList[i].obj == obj) {
					return;
				}
			}
			
			var data:Object = { };
			data.obj = obj;
			
			var ar:MovieClip = new Area();
			_stage.addChild(ar);
			data.area = ar;
			areasList.push(data);
			if (obj.title) {
				ar.title.title = obj.title;
			} else {
				ar.title.visible = false;
			}
			
			/*pivot2.x = xx / stageScale;
			pivot2.y = yy / stageScale;
			pivot2.visible = true;*/
		}
		
		public static function hidePoint():void {
			pivot2.visible = false;
		}
		
		public static function showBounds(rec:Rectangle):void {
			borders.visible = true;
			borders.x = rec.x/ stageScale;
			borders.y = rec.y/ stageScale;
			borders.width = rec.width/ stageScale;
			borders.height = rec.height/ stageScale;
			
		}
		public static function hideBounds():void {
			borders.visible = false;
		}
		
	}

}