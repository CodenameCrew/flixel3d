package flixel3d.math;

class Flx3DPoint {
	public var x:Float;
	public var y:Float;
	public var z:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function set(x:Float, y:Float, z:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function copyFrom(point:Flx3DPoint) {
		this.x = point.x;
		this.y = point.y;
		this.z = point.z;
	}

	public function copyTo(point:Flx3DPoint) {
		point.x = this.x;
		point.y = this.y;
		point.z = this.z;
	}

	public function add(point:Flx3DPoint) {
		this.x += point.x;
		this.y += point.y;
		this.z += point.z;
	}

	public function addEven(value:Float) {
		this.x += value;
		this.y += value;
		this.z += value;
	}

	public function subtract(point:Flx3DPoint) {
		this.x -= point.x;
		this.y -= point.y;
		this.z -= point.z;
	}

	public function subtractEven(value:Float) {
		this.x -= value;
		this.y -= value;
		this.z -= value;
	}

	public function multiply(point:Flx3DPoint) {
		this.x *= point.x;
		this.y *= point.y;
		this.z *= point.z;
	}

	public function multiplyEven(value:Float) {
		this.x *= value;
		this.y *= value;
		this.z *= value;
	}

	public function divide(point:Flx3DPoint) {
		this.x /= point.x;
		this.y /= point.y;
		this.z /= point.z;
	}

	public function divideEven(value:Float) {
		this.x /= value;
		this.y /= value;
		this.z /= value;
	}

	public function normalize() {
		var len = length();
		if (len != 0) {
			divideEven(len);
		}
	}

	public function length() {
		return Math.sqrt(x * x + y * y + z * z);
	}

	public function dot(point:Flx3DPoint) {
		return x * point.x + y * point.y + z * point.z;
	}

	public function cross(point:Flx3DPoint) {
		return new Flx3DPoint(y * point.z - z * point.y, z * point.x - x * point.z, x * point.y - y * point.x);
	}
}
