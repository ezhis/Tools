/**
name: Trig
type: static class 
package: com.jimisaacs.utils

description: Trig is a static class
It is a utility for trigonometric functions and shortcuts.
Such as, the age old degree to radian and vice versa.

author:			Jim Isaacs
author uri:		http://jimisaacs.com

	Copyright (c) 2008 Jim Isaacs
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to 
	deal in the Software without restriction, including without limitation the
	rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
	sell copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
	IN THE SOFTWARE.
*/

// START PACKAGE
package tools.math.geom {
	
	import flash.geom.Point;
	
	// START CLASS
	public class Trig {
				
		/**
		 * STATIC
		 */
		
		/* convert a degree to a radian */
		public static function radian(d:Number):Number {
			return d * (Math.PI / 180);
		}
		
		/* convert a radian to a degree */
		public static function degree(r:Number):Number {
			return r / (Math.PI / 180);
		}
		
		/* correct a numeric value to a basic 0 to 360 degree value.
		Currently in Actionscript degree values may be negative, and infinite, so -90 is the same as 270, and 900 is the same as 180. 
		This function corrects any degree value to its respective positive 0 to 360 counterpart */
		public static function correctDegree(v:Number):Number {
			var a:Number = v / 360;
			return (a - Math.floor(a)) * 360;
		}
		
		/* find the angle of trajectory from two given points */
		public static function getAngle(a:Point, b:Point):Number {
			return (Math.atan2(b.y - a.y, b.x - a.x) * 180) / Math.PI;
		}
		
		/* get the distance from two given points */
		public static function getDistance(a:Point, b:Point):Number {
			return Math.sqrt(Math.pow(b.y - a.y, 2) + Math.pow(b.x - a.x, 2));
		}
	}
	// END CLASS
}
// END PACKAGE