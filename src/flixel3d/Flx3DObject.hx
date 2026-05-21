package flixel3d;

import lime.utils.Float32Array;
import flixel3d.math.Flx3DEuler;
import flixel.FlxObject;
import flixel3d.math.Flx3DPoint;
import flixel.math.FlxVelocity;
import flixel3d.math.Flx3DRotation;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
#if (flixel < "5.7.0")
import flixel3d.internal.compat.FlxContainer;
#end

class Flx3DObject extends FlxObject #if (flixel < "5.7.0") implements IContainerCompat #end {
	private var _ignorePosition:Bool = false;
	private var _matrix:Matrix3D = new Matrix3D();
	private var _rawMatrix:Float32Array = new Float32Array(16);
	private var _rotation:Flx3DRotation = new Flx3DRotation();

	// Angular velocity
	public var angularVelocity3D:Flx3DPoint = new Flx3DPoint();
	public var angularMaxVelocity3D:Flx3DPoint = new Flx3DPoint();
	public var angularAcceleration3D:Flx3DPoint = new Flx3DPoint();
	public var angularDrag3D:Flx3DPoint = new Flx3DPoint();

	// Normal velocity
	public var velocity3D:Flx3DPoint = new Flx3DPoint();
	public var maxVelocity3D:Flx3DPoint = new Flx3DPoint();
	public var acceleration3D:Flx3DPoint = new Flx3DPoint();
	public var drag3D:Flx3DPoint = new Flx3DPoint();

	public var z:Float;
	public var depth:Float;

	// Angle
	public var angleX(get, set):Float;
	public var angleY(get, set):Float;
	public var angleZ(get, set):Float;

	public var quaternionX(get, set):Float;
	public var quaternionY(get, set):Float;
	public var quaternionZ(get, set):Float;
	public var quaternionW(get, set):Float;

	#if (flixel < "5.7.0")
	public var container:FlxContainer;
	#end

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, width:Float = 0, height:Float = 0, depth:Float = 0) {
		this.z = z;
		this.depth = depth;
		super();
	}

	override function updateMotion(elapsed:Float) {
		super.updateMotion(elapsed);

		// Angular velocity
		// X-axis
		var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(angularVelocity3D.x, angularAcceleration3D.x, angularDrag3D.x, angularMaxVelocity3D.x, elapsed) - angularVelocity3D.x);
		angularVelocity3D.x += velocityDelta;
		var angleDeltaX = angularVelocity3D.x * elapsed;
		angularVelocity3D.x += velocityDelta;
		angleX += angleDeltaX;

		// Y-axis
		var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(angularVelocity3D.y, angularAcceleration3D.y, angularDrag3D.y, angularMaxVelocity3D.y, elapsed) - angularVelocity3D.y);
		angularVelocity3D.y += velocityDelta;
		var angleDeltaY = angularVelocity3D.y * elapsed;
		angularVelocity3D.y += velocityDelta;
		angleY += angleDeltaY;

		// Z-axis
		var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(angularVelocity3D.z, angularAcceleration3D.z, angularDrag3D.z, angularMaxVelocity3D.z, elapsed) - angularVelocity3D.z);
		angularVelocity3D.z += velocityDelta;
		var angleDeltaZ = angularVelocity3D.z * elapsed;
		angularVelocity3D.z += velocityDelta;
		angleZ += angleDeltaZ;

		// Velocity
		// X-axis
		var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(velocity3D.x, acceleration3D.x, drag3D.x, maxVelocity3D.x, elapsed) - velocity3D.x);
		velocity3D.x += velocityDelta;
		var deltaX = velocity3D.x * elapsed;
		velocity3D.x += velocityDelta;
		x += deltaX;

		// Y-axis
		var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(velocity3D.y, acceleration3D.y, drag3D.y, maxVelocity3D.y, elapsed) - velocity3D.y);
		velocity3D.y += velocityDelta;
		var deltaY = velocity3D.y * elapsed;
		velocity3D.y += velocityDelta;
		y += deltaY;

		// Z-axis
		var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(velocity3D.z, acceleration3D.z, drag3D.z, maxVelocity3D.z, elapsed) - velocity3D.z);
		velocity3D.z += velocityDelta;
		var deltaZ = velocity3D.z * elapsed;
		velocity3D.z += velocityDelta;
		z += deltaZ;
	}

	/*
		var order = [0, 1, 2];
		for (v in order) {
			switch (v) {
				case 0: _matrix.appendRotation(angleY, new Vector3D(0, 1, 0));
				case 1: _matrix.appendRotation(-angleX, new Vector3D(1, 0, 0));
				case 2: _matrix.appendRotation(-angleZ, new Vector3D(0, 0, 1));
			}
		}
	 */
	@:noCompletion public function getTransformMatrix():Float32Array {
		_matrix.identity();

		_matrix.appendRotation(angleY, new Vector3D(0, 1, 0));
		_matrix.appendRotation(-angleX, new Vector3D(1, 0, 0));
		_matrix.appendRotation(-angleZ, new Vector3D(0, 0, 1));

		if (!_ignorePosition) // this is mainly used for the camera
			_matrix.appendTranslation(x, y, z);

		// convert OpenFL matrix to Float32Array
		var p = 0;
		for (i in 0...16) {
			_rawMatrix[p] = _matrix.rawData[i];
			p += 4;
			if (p >= 16) {
				p -= 15;
			}
		}
		return _rawMatrix;
	}

	public inline function get_angleX():Float {
		_rotation.convert(Flx3DRotationType.EULER);
		return _rotation.euler.x;
	}

	public inline function set_angleX(value:Float):Float {
		_rotation.convert(Flx3DRotationType.EULER);
		return _rotation.euler.x = value;
	}

	public inline function get_angleY():Float {
		_rotation.convert(Flx3DRotationType.EULER);
		return _rotation.euler.y;
	}

	public inline function set_angleY(value:Float):Float {
		_rotation.convert(Flx3DRotationType.EULER);
		return _rotation.euler.y = value;
	}

	public inline function get_angleZ():Float {
		_rotation.convert(Flx3DRotationType.EULER);
		return _rotation.euler.z;
	}

	public inline function set_angleZ(value:Float):Float {
		_rotation.convert(Flx3DRotationType.EULER);
		return _rotation.euler.z = value;
	}

	public inline function get_quaternionX():Float {
		_rotation.convert(Flx3DRotationType.QUATERNION);
		return _rotation.quaternion.x;
	}

	public inline function set_quaternionX(value:Float):Float {
		_rotation.convert(Flx3DRotationType.QUATERNION);
		return _rotation.quaternion.x = value;
	}

	public inline function get_quaternionY():Float {
		_rotation.convert(Flx3DRotationType.QUATERNION);
		return _rotation.quaternion.y;
	}

	public inline function set_quaternionY(value:Float):Float {
		_rotation.convert(Flx3DRotationType.QUATERNION);
		return _rotation.quaternion.y = value;
	}

	public inline function get_quaternionZ():Float {
		_rotation.convert(Flx3DRotationType.QUATERNION);
		return _rotation.quaternion.z;
	}

	public inline function set_quaternionZ(value:Float):Float {
		_rotation.convert(Flx3DRotationType.QUATERNION);
		return _rotation.quaternion.z = value;
	}

	public inline function get_quaternionW():Float {
		_rotation.convert(Flx3DRotationType.QUATERNION);
		return _rotation.quaternion.w;
	}

	public inline function set_quaternionW(value:Float):Float {
		_rotation.convert(Flx3DRotationType.QUATERNION);
		return _rotation.quaternion.w = value;
	}
}
