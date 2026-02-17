package flixel3d;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.typeLimit.OneOfThree;
import flixel3d.math.Flx3DPoint;
import flixel3d.loaders.BaseLoader;
import flixel3d.loaders.FbxLoader;
import flixel3d.loaders.ObjLoader;
import flixel3d.system.Flx3DAssets.Flx3DMeshFormat;
import lime.utils.Float32Array;
import flixel.util.FlxColor;
import flixel3d.render.Flx3DRenderBuffer;

/**
 * This is a sprite which renders a single 3d model,
 * if combined with the FlxScene class, it can be used to render multiple models at once.
 * This class makes it so you can render a single object and layer it on top of another object.
 * Flx3DModels do not appear on regular `FlxCamera`s, only `FlxCamera3D`s.
**/
@:access(flixel3d.render.Flx3DRenderBuffer)
class Flx3DModel extends Flx3DObject {
	private var views:Array<Flx3DRenderBuffer>;
	private var mx:Float32Array;

	public var color:FlxColor = 0xFFFFFFFF;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		meshes = [];
		mx = new Float32Array(16);
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
	**/
	public function loadMeshes(source:String) {
		meshes = FlxG3D.mesh.load(source);
		return this;
	}

	public function setMesh(id:String, data:flixel3d.Flx3DMesh) {
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
		for (view in views) {
			view.addToRenderQueue(this);
		}
	}
}
