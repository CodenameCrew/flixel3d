/**
 * Flx3DRotation is being merged with FlxTransform and will likely not be used. This is only here for archival purposes.
 */

package flixel3d.math;

abstract Flx3DRotationType(Int) from Int from UInt to Int to UInt {
	public static inline var EULER:Flx3DRotationType = 0;
	public static inline var QUATERNION:Flx3DRotationType = 1;
}

/**
 * Flx3DRotation is an abstraction which supports both Euler and Quaternion rotation using `Flx3DEuler` and `Flx3DQuaternion`.
 */
class Flx3DRotation {
	/**
	 * Dev note: should this be public or private?
	**/
	private var type:Flx3DRotationType;

	public var euler(default, null):Flx3DEuler;
	public var quaternion(default, null):Flx3DQuaternion;

	public function new() {
		this.type = Flx3DRotationType.EULER;
		this.euler = new Flx3DEuler();
		this.quaternion = new Flx3DQuaternion();
	}

	/**
	 * Converts to a different type of rotation.
	 *
	 * @param	type		The type of rotation to convert to.
	**/
	public function convert(type:Flx3DRotationType) {
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
	public function convertFast(type:Flx3DRotationType) {
		if (this.type != type) {
			this.type = type;
			switch (type) {
				case EULER: quaternion.toEuler(euler);
				case QUATERNION: euler.toQuaternionFast(quaternion);
			}
		}
	}
}
