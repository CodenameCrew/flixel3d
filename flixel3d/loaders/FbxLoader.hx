package flixel3d.loaders;

import haxe.exceptions.NotImplementedException;

/**
 * Loads .fbx files
 *
 * Spec: https://docs.fileformat.com/3d/fbx/
**/
class FbxLoader extends BaseLoader {
	public function new() {
		super("fbx");
	}

	public function load(data:OneOfTwo<String, haxe.io.Bytes>) {
		throw new NotImplementedException();
	}
}
