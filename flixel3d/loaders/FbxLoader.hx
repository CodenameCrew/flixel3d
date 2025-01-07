package flixel3d.loaders;

import haxe.exceptions.NotImplementedException;
import flixel.util.typeLimit.OneOfTwo;

/**
 * Loads .fbx files
 *
 * Spec: https://docs.fileformat.com/3d/fbx/
**/
class FbxLoader extends BaseLoader {
	public function new() {
		super("fbx");
	}

	public override function load(data:OneOfTwo<String, haxe.io.Bytes>):FlxMesh {
		throw new NotImplementedException();
	}
}
