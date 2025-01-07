/**
 * FlxRotation3D is being merged with FlxTransform and will likely not be used. This is only here for archival purposes.
 */

package flixel3d.math;

abstract FlxRotationType(Int) from Int from UInt to Int to UInt {
	public static inline var EULER:FlxRotationType = 0;
	public static inline var QUATERNION:FlxRotationType = 1;
}

/**
 * FlxRotation3D is an abstraction which supports both Euler and Quaternion rotation using `FlxEuler` and `FlxQuaternion`.
 */
class FlxRotation3D {
	/**
	 * Dev note: should this be public or private?
	**/
	private var type:FlxRotationType;

	public var euler:FlxEuler;
	public var quaternion:FlxQuaternion;

	public function new() {
		this.type = FlxRotationType.EULER;
		this.euler = new FlxEuler();
		this.quaternion = new FlxQuaternion();
	}

	/**
	 * Converts to a different type of rotation.
	 *
	 * @param	type		The type of rotation to convert to.
	**/
	public function convert(type:FlxRotationType) {
		if (this.type != type) {
			this.type = type;
			switch (type) {
				case EULER: quaternion.toEuler(euler);
				case QUATERNION: euler.toQuaternion(quaternion);
			}
		}
	}

	/**
	 * Same as convert, except it uses Flixel's fastSin and fastCos methods when converting euler angles to quaternions, making it faster but slightly less accurate.
	 * This has no effect on conversions from quaternion to euler angles.
	 *
	 * @param	type		The type of rotation to convert to.
	**/
	public function convertFast(type:FlxRotationType) {
		if (this.type != type) {
			this.type = type;
			switch (type) {
				case EULER: quaternion.toEuler(euler);
				case QUATERNION: euler.toQuaternionFast(quaternion);
			}
		}
	}
}
