package flixel3d;

import lime.utils.Float32Array;
import flixel.FlxObject;
import flixel3d.math.Flx3DPoint;
import flixel3d.math.Flx3DRotationMode;
import flixel3d.math.Flx3DMath;
import flixel.math.FlxVelocity;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import openfl.Vector;
import openfl.geom.Orientation3D;
#if (flixel < "5.7.0")
import flixel3d.internal.compat.FlxContainer;
#end

class Flx3DObject extends FlxObject #if (flixel < "5.7.0") implements IContainerCompat #end {
	private var _ignorePosition:Bool = false;
	private var _matrix:Matrix3D = new Matrix3D();
	private var _rawMatrix:Float32Array = new Float32Array(16);
	private var _decomposedMatrix:Vector<Vector3D>;

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
	public var rotationMode:Flx3DRotationMode = YXZ_EULER;
	public var angleX:Float;
	public var angleY:Float;
	public var angleZ:Float;
	public var angleW:Float;

	public var scale:Flx3DPoint = new Flx3DPoint(1, 1, 1);

	#if (flixel < "5.7.0")
	public var container:FlxContainer;
	#end

	/**
	 * @param x			The initial X position of the Flx3DObject.
	 * @param y			The initial Y position of the Flx3DObject.
	 * @param Z			The initial Z position of the Flx3DObject.
	 * @param width		The desired width of the Flx3DObject.
	 * @param height	The desired height of the Flx3DObject.
	 * @param depth		The desired depth (length along the Z axis) of the Flx3DObject.
	**/
	public function new(x:Float = 0, y:Float = 0, z:Float = 0, width:Float = 0, height:Float = 0, depth:Float = 0) {
		this.z = z;
		this.depth = depth;
		super(x, y);

		_decomposedMatrix = new Vector<Vector3D>();
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

	@:dox(hide) @:noCompletion public function getTransformMatrix():Float32Array {
		_matrix.identity();

		_matrix.appendScale(scale.x, scale.y, scale.z);

		switch (rotationMode) {
			case XYZ_EULER:
				_matrix.appendRotation(-angleX, Vector3D.X_AXIS);
				_matrix.appendRotation(angleY, Vector3D.Y_AXIS);
				_matrix.appendRotation(-angleZ, Vector3D.Z_AXIS);
			case YXZ_EULER:
				_matrix.appendRotation(angleY, Vector3D.Y_AXIS);
				_matrix.appendRotation(-angleX, Vector3D.X_AXIS);
				_matrix.appendRotation(-angleZ, Vector3D.Z_AXIS);
			case ZYX_EULER:
				_matrix.appendRotation(-angleZ, Vector3D.Z_AXIS);
				_matrix.appendRotation(angleY, Vector3D.Y_AXIS);
				_matrix.appendRotation(-angleX, Vector3D.X_AXIS);
			case ZXY_EULER:
				_matrix.appendRotation(-angleZ, Vector3D.Z_AXIS);
				_matrix.appendRotation(-angleX, Vector3D.X_AXIS);
				_matrix.appendRotation(angleY, Vector3D.Y_AXIS);
			case XZY_EULER:
				_matrix.appendRotation(-angleX, Vector3D.X_AXIS);
				_matrix.appendRotation(-angleZ, Vector3D.Z_AXIS);
				_matrix.appendRotation(angleY, Vector3D.Y_AXIS);
			case YZX_EULER:
				_matrix.appendRotation(angleY, Vector3D.Y_AXIS);
				_matrix.appendRotation(-angleZ, Vector3D.Z_AXIS);
				_matrix.appendRotation(-angleX, Vector3D.X_AXIS);
			case QUATERNION:
				_matrix.decomposeToOutput(Orientation3D.QUATERNION, _decomposedMatrix);

				var matrixRotation = _decomposedMatrix[1];
				matrixRotation.setTo(angleX, angleY, angleZ);
				matrixRotation.w = angleW;

				_matrix.recompose(_decomposedMatrix, Orientation3D.QUATERNION);
		}

		if (!_ignorePosition) // _ignorePosition is mainly used for the camera
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
}
