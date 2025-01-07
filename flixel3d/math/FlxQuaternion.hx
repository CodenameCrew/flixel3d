package flixel3d.math;

class FlxQuaternion {
	public function new(x:Float, y:Float, z:Float, w:Float) {
		set(x, y, z, w);
	}

	public function set(x:Float, y:Float, z:Float, w:Float):FlxQuaternion {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;

		return this;
	}

	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;

	public function toEuler(?euler:FlxEuler):FlxEuler {
		if (euler == null)
			euler = new FlxEuler();

		// roll (x-axis rotation)
		var sinrCosp:Float = 2 * (w * x + y * z);
		var cosrCosp:Float = 1 - 2 * (x * x + y * y);
		euler.roll = Math.atan2(sinrCosp, cosrCosp);

		// pitch (y-axis rotation)
		var sinp:Float = Math.sqrt(1 + 2 * (w * y - x * z));
		var cosp:Float = Math.sqrt(1 - 2 * (w * y - x * z));
		euler.pitch = 2 * Math.atan2(sinp, cosp) - Math.PI / 2;

		// yaw (z-axis rotation)
		var sinyCosp:Float = 2 * (w * z + x * y);
		var cosyCosp:Float = 1 - 2 * (y * y + z * z);
		euler.yaw = Math.atan2(sinyCosp, cosyCosp);

		return euler;
	}
}
