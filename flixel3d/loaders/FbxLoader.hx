package flixel3d.loaders;

import haxe.exceptions.NotImplementedException;
import flixel.util.typeLimit.OneOfTwo;

/**
 * Loads .fbx files
 *
 * Spec: https://docs.fileformat.com/3d/fbx/
 *
 * Note: Not yet implemented.
 */
class FbxLoader extends BaseLoader {
	public function new() {
		throw new NotImplementedException();
		super("fbx");
	}

	public override function load(data:OneOfTwo<String, haxe.io.Bytes>):Map<String, Flx3DGeometry> {
		throw new NotImplementedException();
	}
}
