package flixel3d;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.typeLimit.OneOfTwo;
import flixel3d.math.FlxPoint3D;
import flixel3d.loaders.BaseLoader;
import flixel3d.loaders.FbxLoader;
import flixel3d.loaders.ObjLoader;

/**
 * This is a sprite which renders a single 3d model,
 * if combined with the FlxScene class, it can be used to render multiple models at once.
 * This class makes it so you can render a single object and layer it on top of another object.
 *
 * Dev note: im not sure if i should use FlxSprite or FlxBasic here
**/
class FlxModel extends FlxSprite {
	public var z:Float;

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

	// Angle
	public var angleX:Float;
	public var angleY:Float;
	public var angleZ:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		super(x, y);
		this.z = z;
	}

	public var mesh:FlxMesh;

	/**
	 * Data can be either a path or a haxe.io.Bytes class of the data
	**/
	public function loadFbxModel(data:OneOfTwo<String, haxe.io.Bytes>) {
		loader = new FbxLoader();
		loader.load(data);
		// TODO: used the parsed data
	}

	/**
	 * Data can be either a path or a haxe.io.Bytes class of the data
	**/
	public function loadObjModel(data:OneOfTwo<String, haxe.io.Bytes>) {
		loader = new ObjLoader();
		loader.load(data);
		// TODO: used the parsed data
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
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
