package flixel3d.math;

import flixel3d.FlxObject3D;
import lime.utils.Float32Array;

class MatrixUtil {
	private static final deg2rad = (Math.PI / 180);

	// private static var matrix:Float32Array = new Float32Array(16);

	/*public static macro function __cacheSin()
		{
			var cache:Float32Array = new Float32Array(360);
			for (i in 0...360)
			{
				cache[i] = Math.sin(i * deg2rad);
			}
			return macro $v{cache};
		}
		private static var __cachedSinValues:Float32Array = __cacheSin();
		private static var matrix:Float32Array = new Float32Array();
		private static function cachedSin(deg:Float)
		{
			return __cachedSinValues[Math.round(deg) % 360];
		}

		private static function cachedCos(deg:Float)
		{
			return cachedSin(90 - deg);
	}*/
	/*public static function calculateTransform(obj:FlxObject3D, ?matrix:Float32Array):Float32Array {
		if (matrix == null)
			matrix = new Float32Array(16);
		// dev note: should i be sentenced to death?

		var rx:Float = obj.angleX;
		var ry:Float = obj.angleY;
		var rz:Float = obj.angleZ;

		var rxs:Float = Math.sin(rx);
		var rxc:Float = Math.cos(rx);

		var rys:Float = Math.sin(rx);
		var ryc:Float = Math.cos(rx);

		var rzs:Float = Math.sin(rx);
		var rzc:Float = Math.cos(rx);

		// stored in column-major form
		matrix[0] = rzc * ryc;
		matrix[1] = rzc * rys * rxc - rzs * rxc;
		matrix[2] = rzc * rys * rxc + rzs * rxc;
		matrix[3] = obj.x;

		matrix[4] = rzs * ryc;
		matrix[5] = rzs * rys * rxc + rzc * rxc;
		matrix[6] = rzs * rys * rxc - rzc * rxc;
		matrix[7] = obj.y;

		matrix[8] = -rys;
		matrix[9] = ryc * rxc;
		matrix[10] = ryc * rxc;
		matrix[11] = obj.z;

		matrix[12] = 0.;
		matrix[13] = 0.;
		matrix[14] = 0.;
		matrix[15] = 1.;

		return matrix;
	}*/
	public static function calculateTransform(obj:FlxObject3D, ?mx:Float32Array, ignorePosition:Bool = false):Float32Array {
		// dev note: should i be sentenced to death?
		if (mx == null)
			mx = new Float32Array(16);

		var rx:Float = obj.angleX * deg2rad;
		var ry:Float = obj.angleY * deg2rad;
		var rz:Float = obj.angleZ * deg2rad; // (obj.angleZ + (ignorePosition ? 180 : 0))

		var x:Float = 0;
		var y:Float = 0;
		var z:Float = 0;

		if (!ignorePosition) {
			x = obj.x;
			y = obj.y;
			z = obj.z;
		}

		var srx:Float = Math.sin(rx);
		var crx:Float = Math.cos(rx);

		var sry:Float = Math.sin(ry);
		var cry:Float = Math.cos(ry);

		var srz:Float = Math.sin(rz);
		var crz:Float = Math.cos(rz);

		// stored in column-major form
		mx[0] = crz * cry;
		mx[1] = crz * sry * srx - srz * crx;
		mx[2] = crz * sry * crx + srz * srx;
		mx[3] = x;

		mx[4] = srz * cry;
		mx[5] = srz * sry * srx + crz * crx;
		mx[6] = srz * sry * crx - crz * srx;
		mx[7] = y;

		mx[8] = -sry;
		mx[9] = cry * srx;
		mx[10] = cry * crx;
		mx[11] = z;

		mx[12] = 0.;
		mx[13] = 0.;
		mx[14] = 0.;
		mx[15] = 1.;

		return mx;
	}
}
