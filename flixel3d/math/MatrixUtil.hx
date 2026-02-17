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
@:deprecated class MatrixUtil {
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
		var matrix = new Matrix3D();
		matrix.identity();

		// allows rotation to be dynamically ordered
		var order = [0, 1, 2];
		for (v in order) {
			switch (v) {
				case 0: matrix.appendRotation(obj.angleY, new Vector3D(0, 1, 0));
				case 1: matrix.appendRotation(-obj.angleX, new Vector3D(1, 0, 0));
				case 2: matrix.appendRotation(-obj.angleZ, new Vector3D(0, 0, 1));
			}
		}

		if (!ignorePosition)
			matrix.appendTranslation(obj.x, obj.y, obj.z);

		if (mx == null)
			mx = new Float32Array(16);

		var p = 0;
		for (i in 0...16) {
			mx[p] = matrix.rawData[i];
			p += 4;
			if (p >= 16) {
				p -= 15;
			}
		}
		return mx;
	}

	function float32MatrixToString(array:Float32Array):String {
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
}
