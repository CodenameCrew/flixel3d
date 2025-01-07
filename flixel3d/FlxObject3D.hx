package flixel3d;

import flixel.FlxObject;
import flixel3d.math.FlxPoint3D;
import flixel.math.FlxVelocity;

class FlxObject3D extends FlxObject {
	// Angular velocity
	public var angularVelocity3D:FlxPoint3D = new FlxPoint3D();
	public var angularMaxVelocity3D:FlxPoint3D = new FlxPoint3D();
	public var angularAcceleration3D:FlxPoint3D = new FlxPoint3D();
	public var angularDrag3D:FlxPoint3D = new FlxPoint3D();

	// Normal velocity
	public var velocity3D:FlxPoint3D = new FlxPoint3D();
	public var maxVelocity3D:FlxPoint3D = new FlxPoint3D();
	public var acceleration3D:FlxPoint3D = new FlxPoint3D();
	public var drag3D:FlxPoint3D = new FlxPoint3D();

	public var z:Float;
	public var depth:Float;

	// Angle
	public var angleX:Float;
	public var angleY:Float;
	public var angleZ:Float;

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
}
