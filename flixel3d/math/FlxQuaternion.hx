package flixel3d.math;

class FlxQuaternion {
	public function new(x:Float, y:Float, z:Float, w:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;

	public function toEuler():FlxEuler {
		var angles:FlxEuler = new FlxEuler();

		// roll (x-axis rotation)
		var sinr_cosp:Float = 2 * (w * x + y * z);
		var cosr_cosp:Float = 1 - 2 * (x * x + y * y);
		angles.roll = Math.atan2(sinr_cosp, cosr_cosp);

		// pitch (y-axis rotation)
		var sinp:Float = Math.sqrt(1 + 2 * (w * y - x * z));
		var cosp:Float = Math.sqrt(1 - 2 * (w * y - x * z));
		angles.pitch = 2 * Math.atan2(sinp, cosp) - Math.PI / 2;

		// yaw (z-axis rotation)
		var siny_cosp:Float = 2 * (w * z + x * y);
		var cosy_cosp:Float = 1 - 2 * (y * y + z * z);
		angles.yaw = Math.atan2(siny_cosp, cosy_cosp);

		return angles;
	}
}
