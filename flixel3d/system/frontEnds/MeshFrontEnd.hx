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
	/*public inline function addMeshes(mesh:FlxMeshData):FlxMeshData {
		_cache.set(mesh.key, mesh);
		return mesh;
	}*/
	/**
	 * Gets FlxMeshData object from this storage by specified key.
	 * @param	key	Key for FlxMeshData object (its name)
	 * @return	FlxMeshData with the key name, or null if there is no such object
	 */
	/*public inline function get(key:String):FlxMeshData {
		return _cache.get(key);
	}*/
	public static inline function getFormatFromExtension(path:String) {
		return switch (path.substring(path.lastIndexOf("."))) {
			case '.obj': FlxMeshFormat.OBJ;
			case '.fbx': FlxMeshFormat.FBX;
			default: FlxMeshFormat.RAW;
		}
	}

	public function load(source:String):Map<String, FlxMesh> {
		var format = getFormatFromExtension(source);
		var loader:BaseLoader;
		switch (format) {
			case FlxMeshFormat.OBJ: loader = new ObjLoader();
			default: throw new NotImplementedException("Wavefront OBJ (.obj) is currently the only supported model format.");
		}

		var datas = loader.load(source);

		var meshes:Map<String, FlxMesh> = new Map<String, FlxMesh>();
		for (data in datas.keyValueIterator()) {
			meshes.set(data.key, new FlxMesh(data.value));
		}

		// loadedMesh.key = source; // key ?? source;
		// FlxG3D.mesh.addMesh(loadedMesh);
		return meshes;
	}
}
