package flixel3d;

import haxe.exceptions.NotImplementedException;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.typeLimit.OneOfThree;
import flixel3d.Flx3DMesh;
import flixel3d.math.Flx3DPoint;
import flixel3d.loaders.BaseLoader;
import flixel3d.loaders.FbxLoader;
import flixel3d.loaders.ObjLoader;
import flixel3d.system.Flx3DAssets.Flx3DMeshFormat;
import lime.utils.Float32Array;
import flixel.util.FlxColor;
import flixel3d.render.Flx3DRenderBuffer;

/**
 * Flx3DModel represents a 3D model which can be added to an `Flx3DScene`.
 * It is a collection of multiple `Flx3DMesh`es.
 */
@:access(flixel3d.render.Flx3DRenderBuffer)
class Flx3DModel extends Flx3DObject {
	private var views:Array<Flx3DRenderBuffer>;

	public var color:FlxColor = 0xFFFFFFFF;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		meshes = [];
		super(x, y, z);
		views = new Array<Flx3DRenderBuffer>();
	}

	public function forEachMesh(func:(name:String, mesh:Flx3DMesh) -> Void) {
		for (kv in meshes.keyValueIterator()) {
			func(kv.key, kv.value);
		}
	}

	public var meshes:Map<String, Flx3DMesh>;

	/**
	 * Loads all meshes from the obj file.
	 */
	public function loadMeshes(source:String) {
		throw new NotImplementedException();
		// meshes = FlxG3D.mesh.load(source);
		return this;
	}

	public function setMesh(id:String, mesh:Flx3DMesh) {
		meshes.set(id, mesh);
		return this;
	}

	public function getMesh(id:String) {
		return meshes.get(id);
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
	}

	public override function draw() {
		for (view in views) {
			view.addToRenderQueue(this);
		}
	}
}
