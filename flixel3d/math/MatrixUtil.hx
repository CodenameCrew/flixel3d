package flixel3d.math;

import haxe.io.Float32Array;
import flixel3d.Flx3DObject;
import lime.utils.Float32Array;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import openfl.utils.PerspectiveMatrix3D;

/*
	mx[0] = cry * crx;
	mx[1] = srz * sry * crx - crz * srx;
	mx[2] = crz * sry * crx + srz * srx;
	mx[3] = x;

	mx[4] = cry * srx;
	mx[5] = srz * sry * srx + crz * crx;
	mx[6] = crz * sry * srz - srz * crx;
	mx[7] = y;

	mx[8] = -sry;
	mx[9] = srz * cry;
	mx[10] = crz * cry;
	mx[11] = z; */
class MatrixUtil {
	private static final deg2rad = (Math.PI / 180);

	public static function perspective(camera:Flx3DCamera) {
		var matrix = new PerspectiveMatrix3D();
		matrix.identity();
		matrix.perspectiveFieldOfViewRH(camera.fov, 16 / 9, 0.1, 1000);

		var mx = new Float32Array(16);
		for (i in 0...16) {
			mx[i] = matrix.rawData[i];
		}
		return mx;
	}

	public static function calculateTransform(obj:Flx3DObject, ?mx:Float32Array, ignorePosition:Bool = false):Float32Array {
		return oldCalculateTransform(obj, mx, ignorePosition);
		var matrix = new Matrix3D();
		matrix.identity();
		matrix.appendRotation(obj.angleX, new Vector3D(1, 0, 0));
		matrix.appendRotation(obj.angleY, new Vector3D(0, 1, 0));
		matrix.appendRotation(obj.angleZ, new Vector3D(0, 0, 1));
		matrix.appendTranslation(obj.x, obj.y, obj.z);

		if (mx == null)
			mx = new Float32Array(16);

		inline function float32MatrixToString(array:Float32Array):String {
			var matrixString = "";
			for (i in 0...16) {
				var xPos = i % 4;
				if (xPos == 0) {
					matrixString += "[";
				}

				matrixString += Std.string(array[i]);

				if (xPos == 3) {
					matrixString += "]\n";
				} else {
					matrixString += ", ";
				}
			}
			return matrixString;
		}

		for (i in 0...16) {
			mx[i] = matrix.rawData[i];
		}

		/*trace("===== OLD MATRIX =====");
			trace(float32MatrixToString(oldCalculateTransform(obj, null, ignorePosition)));
			trace("===== NEW MATRIX =====");
			trace(float32MatrixToString(mx));
			trace("======================"); */

		return mx;
	}

	public static function oldCalculateTransform(obj:Flx3DObject, ?mx:Float32Array, ignorePosition:Bool = false):Float32Array {
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
