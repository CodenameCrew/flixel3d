package flixel3d.system.frontEnds;

import flixel3d.system.Flx3DAssets;
import flixel3d.loaders.BaseLoader;
import flixel3d.loaders.ObjLoader;
import haxe.exceptions.NotImplementedException;

class MeshFrontEnd {
	public function new() {}

	/**
	 * Caches specified FlxGraphic object.
	 *
	 * @param	graphic	FlxGraphic to store in the cache.
	 * @return	cached FlxGraphic object.
	 */
	/*public inline function addMeshes(mesh:Flx3DMeshData):Flx3DMeshData {
		_cache.set(mesh.key, mesh);
		return mesh;
	}*/
	/**
	 * Gets Flx3DMeshData object from this storage by specified key.
	 * @param	key	Key for Flx3DMeshData object (its name)
	 * @return	Flx3DMeshData with the key name, or null if there is no such object
	 */
	/*public inline function get(key:String):Flx3DMeshData {
		return _cache.get(key);
	}*/
	public static inline function getFormatFromExtension(path:String) {
		return switch (path.substring(path.lastIndexOf("."))) {
			case '.obj': Flx3DMeshFormat.OBJ;
			case '.fbx': Flx3DMeshFormat.FBX;
			default: Flx3DMeshFormat.RAW;
		}
	}

	public function load(source:String):Map<String, Flx3DMesh> {
		var format = getFormatFromExtension(source);
		var loader:BaseLoader;
		switch (format) {
			case Flx3DMeshFormat.OBJ: loader = new ObjLoader();
			default: throw new NotImplementedException("Wavefront OBJ (.obj) is currently the only supported model format.");
		}

		var datas = loader.load(source);

		var meshes:Map<String, Flx3DMesh> = new Map<String, Flx3DMesh>();
		for (data in datas.keyValueIterator()) {
			meshes.set(data.key, new Flx3DMesh(data.value));
		}

		// loadedMesh.key = source; // key ?? source;
		// FlxG3D.mesh.addMesh(loadedMesh);
		return meshes;
	}
}
