package flixel3d;

import flixel.FlxBasic;
import flixel.util.FlxColor;
import flixel3d.Flx3DMesh;
import flixel3d.internal.Flx3DSceneContainer;
import flixel3d.math.Flx3DPoint;
import flixel3d.render.Flx3DRenderBuffer;
import flixel3d.materials.Flx3DBaseMaterial;
#if (flixel > "5.7.0")
import flixel.group.FlxContainer;
#else
import flixel3d.internal.compat.FlxContainer;
#end

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
		meshes = FlxG3D.mesh.load(source);
		return this;
	}

	public function applyMaterials(materials:Map<String, Flx3DBaseMaterial>) {
		for (kv in materials.keyValueIterator()) {
			var mesh = getMesh(kv.key);
			if (mesh != null)
				mesh.material = kv.value;
		}
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

	private function findScene<T:#if (flixel < "5.7.0") IContainerCompat #else FlxBasic #end>(container:T):Null<Flx3DRenderBuffer> {
		if (container == null) {
			return null;
		} else if (Std.isOfType(container, Flx3DSceneContainer)) {
			return @:privateAccess (cast container : Flx3DSceneContainer).parentScene;
		} else if (container.container == null)
			return null;
		return findScene(container.container);
	}

	public override function draw() {
		var scene = findScene(container);
		scene?.addToRenderQueue(this);
	}
}
