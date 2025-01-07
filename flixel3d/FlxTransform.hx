package flixel3d;

/*
	import flixel3d.math.FlxPoint3D;
	import lime.utils.Float32Array;
	import flixel3d.math.FlxEuler;

	class FlxTransform {
	public var position:FlxPoint3D;
	public var eulerAngles:FlxEuler;

	private var mx:Float32Array;

	public function new() {
		mx = new Float32Array(16);
		position = new FlxPoint3D();
		eulerAngles = new FlxEuler();
	}

	public function getMatrix():Float32Array {
		// dev note: should i be sentenced to death?

		var rx:Float = eulerAngles.x;
		var ry:Float = eulerAngles.y;
		var rz:Float = eulerAngles.z;

		// stored in column-major form
		mx[0] = cos(rz) * cos(ry);
		mx[4] = cos(rz) * sin(ry) * sin(rx) - sin(rz) * cos(rx);
		mx[8] = cos(rz) * sin(ry) * cos(rx) + sin(rz) * sin(rx);
		mx[12] = position.x;

		mx[1] = sin(rz) * cos(ry);
		mx[5] = sin(rz) * sin(ry) * sin(rx) + cos(rz) * cos(rx);
		mx[9] = sin(rz) * sin(ry) * cos(rx) - cos(rz) * sin(rx);
		mx[13] = position.y;

		mx[2] = -sin(ry);
		mx[6] = cos(ry) * sin(rx);
		mx[10] = cos(ry) * cos(rx);
		mx[14] = position.z;

		mx[3] = 0.;
		mx[7] = 0.;
		mx[11] = 0.;
		mx[15] = 1.;

		return mx;
	}
	}
 */
