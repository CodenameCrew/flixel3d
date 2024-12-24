package flixel3d.math;

import flixel.math.FlxMath;

class FlxEuler {
	public function new(x:Float, y:Float, z:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public var x:Float;
	public var y:Float;
	public var z:Float;

	/**
	 * Alias for x
	**/
	public var pitch(get, set):Float;

	/**
	 * Alias for y
	**/
	public var yaw(get, set):Float;

	/**
	 * Alias for z
	**/
	public var roll(get, set):Float;

	@:noCompletion public function get_pitch() {
		return x;
	}

	@:noCompletion public function get_yaw() {
		return y;
	}

	@:noCompletion public function get_roll() {
		return z;
	}

	@:noCompletion public function set_pitch(value:Float) {
		return x = value;
	}

	@:noCompletion public function set_yaw(value:Float) {
		return y = value;
	}

	@:noCompletion public function set_roll(value:Float) {
		return z = value;
	}

	/**
	 * Converts FlxEuler into an FlxQuaternion.
	**/
	public function toQuaternion():FlxQuaternion {
		var cr:Float = Math.cos(roll * 0.5);
		var sr:Float = Math.sin(roll * 0.5);
		var cp:Float = Math.cos(pitch * 0.5);
		var sp:Float = Math.sin(pitch * 0.5);
		var cy:Float = Math.cos(yaw * 0.5);
		var sy:Float = Math.sin(yaw * 0.5);

		return new FlxQuaternion(
			cr * cp * cy + sr * sp * sy,
			sr * cp * cy - cr * sp * sy,
			cr * sp * cy + sr * cp * sy,
			cr * cp * sy - sr * sp * cy
		);
	}

	/**
	 * Same as toQuaternion, except it uses Flixel's fastSin and fastCos methods, making it faster but slightly less accurate.
	**/
	public function toQuaternionFast():FlxQuaternion {
		var cr:Float = FlxMath.fastCos(roll * 0.5);
		var sr:Float = FlxMath.fastSin(roll * 0.5);
		var cp:Float = FlxMath.fastCos(pitch * 0.5);
		var sp:Float = FlxMath.fastSin(pitch * 0.5);
		var cy:Float = FlxMath.fastCos(yaw * 0.5);
		var sy:Float = FlxMath.fastSin(yaw * 0.5);

		return new FlxQuaternion(
			cr * cp * cy + sr * sp * sy,
			sr * cp * cy - cr * sp * sy,
			cr * sp * cy + sr * cp * sy,
			cr * cp * sy - sr * sp * cy
		);
	}
}
