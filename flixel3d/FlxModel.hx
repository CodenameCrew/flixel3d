package flixel3d;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.typeLimit.OneOfThree;
import flixel3d.math.FlxPoint3D;
import flixel3d.loaders.BaseLoader;
import flixel3d.loaders.FbxLoader;
import flixel3d.loaders.ObjLoader;
import flixel3d.system.Flx3DAssets.FlxMeshFormat;
import lime.utils.Float32Array;
import flixel.util.FlxColor;
import flixel3d.math.MatrixUtil;

/**
 * This is a sprite which renders a single 3d model,
 * if combined with the FlxScene class, it can be used to render multiple models at once.
 * This class makes it so you can render a single object and layer it on top of another object.
 * FlxModels do not appear on regular `FlxCamera`s, only `FlxCamera3D`s.
 *
 * Dev note: im not sure if i should use FlxSprite or FlxBasic here
**/
class FlxModel extends FlxObject3D {
	private var mx:Float32Array;

	public var color:FlxColor = 0xFFFFFFFF;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		meshes = [];
		mx = new Float32Array(16);
		super(x, y, z);
	}

	public function forEachMesh(func:(name:String, mesh:FlxMesh) -> Void) {
		for (kv in meshes.keyValueIterator()) {
			func(kv.key, kv.value);
		}
	}

	/*public function getTransformMatrix():Float32Array {
		// dev note: should i be sentenced to death?

		var rx:Float = angleX;
		var ry:Float = angleY;
		var rz:Float = angleZ;

		// stored in column-major form
		mx[0] = Math.cos(rz) * Math.cos(ry);
		mx[1] = Math.cos(rz) * Math.sin(ry) * Math.sin(rx) - Math.sin(rz) * Math.cos(rx);
		mx[2] = Math.cos(rz) * Math.sin(ry) * Math.cos(rx) + Math.sin(rz) * Math.sin(rx);
		mx[3] = x;

		mx[4] = Math.sin(rz) * Math.cos(ry);
		mx[5] = Math.sin(rz) * Math.sin(ry) * Math.sin(rx) + Math.cos(rz) * Math.cos(rx);
		mx[6] = Math.sin(rz) * Math.sin(ry) * Math.cos(rx) - Math.cos(rz) * Math.sin(rx);
		mx[7] = y;

		mx[8] = -Math.sin(ry);
		mx[9] = Math.cos(ry) * Math.sin(rx);
		mx[10] = Math.cos(ry) * Math.cos(rx);
		mx[11] = z;

		mx[12] = 0.;
		mx[13] = 0.;
		mx[14] = 0.;
		mx[15] = 1.;

		return mx;
	}*/
	public function getTransformMatrix():Float32Array {
		return MatrixUtil.calculateTransform(this, mx);
	}

	public var meshes:Map<String, FlxMesh>;

	/**
	 * Loads all meshes from the obj file.
	**/
	public function loadMeshes(source:String) {
		meshes = FlxG3D.mesh.load(source);
		return this;
	}

	public function setMesh(id:String, data:flixel3d.FlxMesh) {
		meshes.set(id, data);
		return this;
	}

	public function getMesh(id:String) {
		return meshes.get(id);
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
	}

	public override function draw() {
		for (cam in cameras) {
			if (Std.isOfType(cam, FlxCamera3D)) {
				var cam3D:FlxCamera3D = cast cam;
				cam3D.addToRenderQueue(this);
			}
		}
	}
}
