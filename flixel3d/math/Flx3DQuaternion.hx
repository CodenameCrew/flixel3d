package flixel3d.math;

class Flx3DQuaternion {
	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0) {
		set(x, y, z, w);
	}

	public function set(x:Float, y:Float, z:Float, w:Float):Flx3DQuaternion {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;

		return this;
	}

	public var x:Float = 0;
	public var y:Float = 0;
	public var z:Float = 0;
	public var w:Float = 0;

	public function toEuler(?euler:Flx3DEuler):Flx3DEuler {
		if (euler == null)
			euler = new Flx3DEuler();

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
