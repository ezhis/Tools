package tools.math {
	import flash.geom.Point;
	
	public class BezierCurve {
		private var _points:Vector.<Point>;
		private var _controlPointsA:Array;
		private var _controlPointsB:Array;
		private var _closedCurve_state:Boolean = false;
		private var controlDistance:Number;
		private var segments:int;
		private var control:Number;
		public var points:Vector.<Point>;
		
		public function BezierCurve() {
			//init();
			//configureListeners();
		}
		
		/*public function getBezierCurve(pPoints:Vector.<Point>, control:Number = 0.4, segments:int = 5):Vector.<Point> {
			this.segments = segments;
			this.control = control;
			_points = pPoints;
			calculateControlPoints();
			drawCurve();
			return points;
		}
		
		public function setupPoints(pPoints:Vector.<Point>, control:Number = 0.4, segments:int = 5):void {
			this.control = control;
			this.segments = segments;
			_points = pPoints;
		}
		
		public function calculateControlPoints():void {
			//Two Control Points for each control point
			_controlPointsA = new Array(_points.length);
			_controlPointsB = new Array(_points.length);
			
			//calculating first and last point for iteration
			var firstPtIndex:int = 1;
			var lastPtIndex:int = _points.length - 1;
			
			if (_closedCurve_state && _points.length > 2) {
				//If this is a closed curve
				firstPtIndex = 0;
				lastPtIndex = _points.length;
			}
			
			//Looping thru all curve points to calculate control points
			//We loop from  2nd point to 2nd to last point
			//first point and last point are edge cases we come to later
			for (var i:int = firstPtIndex; i < lastPtIndex; i++) {
				//The prev, current and next point in our iteration
				var p0:Point = ((i - 1 < 0) ? _points[_points.length - 2] : _points[i - 1]) as Point;
				var p1:Point = _points[i] as Point;
				var p2:Point = ((i + 1 == _points.length) ? _points[1] : _points[i + 1]) as Point;
				
				//Calculating the distance of points and using a min length
				var a:Number = Point.distance(p0, p1);
				a = Math.max(a, 0.01);
				var b:Number = Point.distance(p1, p2);
				b = Math.max(b, 0.01);
				var c:Number = Point.distance(p2, p0);
				c = Math.max(c, 0.01);
				//Angle between the 2 sides of the triangle
				var C:Number = Math.acos((b * b + a * a - c * c) / (2 * b * a));
				
				//Relative set of points
				var aPt:Point = new Point(p0.x - p1.x, p0.y - p1.y);
				var bPt:Point = new Point(p1.x, p1.y);
				var cPt:Point = new Point(p2.x - p1.x, p2.y - p1.y);
				
				if (a > b) {
					aPt.normalize(b);
				} else if (b > a) {
					cPt.normalize(a);
				}
				
				//Since the points are normalized
				//we put them back to their original position
				aPt.offset(p1.x, p1.y);
				cPt.offset(p1.x, p1.y);
				
				//Calculating vectors ba and bc
				var ax:Number = bPt.x - aPt.x;
				var ay:Number = bPt.y - aPt.y;
				var bx:Number = bPt.x - cPt.x;
				var by:Number = bPt.y - cPt.y;
				//Adding the two vectors gives the line perpendicular to the
				//control point line
				var rx:Number = ax + bx;
				var ry:Number = ay + by;
				var r:Number = Math.sqrt(rx * rx + ry * ry); //not reqd
				var theta:Number = Math.atan(ry / rx);
				
				var controlDist:Number = Math.min(a, b) * control;
				
				var controlScaleFactor:Number = C / Math.PI;
				//controlDist *= ((1-angleFactor)) + (angleFactor*controlScaleFactor));
				var controlAngle:Number = theta + Math.PI / 2;
				
				var cp1:Point = Point.polar(controlDist, controlAngle + Math.PI);
				var cp2:Point = Point.polar(controlDist, controlAngle);
				//offset these control points to put them in the right place
				cp1.offset(p1.x, p1.y);
				cp2.offset(p1.x, p1.y);
				
				//ensureing P1 and P2 are not switched
				if (Point.distance(cp2, p2) > Point.distance(cp1, p2)) {
					//swap cp1 and cp2
					var dummyX:Number = cp1.x;
					cp1.x = cp2.x;
					cp2.x = dummyX;
					var dummyY:Number = cp1.y;
					cp1.y = cp2.y;
					cp2.y = dummyY;
				}
				
				_controlPointsA[i] = cp1;
				_controlPointsB[i] = cp2;
				
			}
		}
		
		public function drawCurve():void {
			//Calculating First and Last Points
			points = new Vector.<Point>();
			var firstPtIndex:int = 1;
			var lastPtIndex:int = _points.length - 1;
			if (_closedCurve_state) {
				//If this is a closed curve
				firstPtIndex = 0;
				lastPtIndex = _points.length + 1;
			}
			
			//If this isnt a closed line
			if (firstPtIndex == 1) {
				//If this is a closed curve
				//Drawing a regular quadratic bezier curve from first to second point
				//using control point of the second point
				points = points.concat(drawBezzFromFourPoints(_points[0], _points[0], _controlPointsA[1], _points[1]));
			}
			
			//Looping thru various points for drawing cubic bezzier curves
			for (var i:int = firstPtIndex; i < lastPtIndex - 1; i++) {
				//var prevIndex:int = ((i-1 < 0) ? _points.length-2 : i-1);
				var nextIndex:int = ((i + 1 == _points.length) ? 0 : i + 1);
				points = points.concat(drawBezzFromFourPoints(_points[i], _controlPointsB[i], _controlPointsA[nextIndex], _points[nextIndex]));
				
			}
			//If this isnt a closed curve 
			if (lastPtIndex == _points.length - 1) {
				points = points.concat(drawBezzFromFourPoints(_points[lastPtIndex - 1], _controlPointsB[_points.length - 2], _points[lastPtIndex], _points[lastPtIndex]));
			}
		}
		
		public function drawBezzFromFourPoints(p1:Point, p2:Point, p3:Point, p4:Point):Vector.<Point> {
			//Util-ish function
			//This function can be optimized to use less than/more than 
			//100 points every time, based on the curvature of the curve
			var points:Vector.<Point> = new Vector.<Point>();
			var bs:BezierSegment = new BezierSegment(p1, p2, p3, p4);
			
			var step:Number = 1 / segments;
			
			for (var t:Number = step; t < 1.01; t += step) {
				var val:Point = bs.getValue(t);
				points.push(new Point(val.x, val.y));
			}
			return points;
		}*/
	
	}
}