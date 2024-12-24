package flixel3d;

import flixel3d.FlxMesh;

/**
 * Dev note: idk
**/
class FlxMeshGroup {
	public var members:Array<FlxMesh>;

	public function new() {
		members = new Array<FlxMesh>();
	}

	public function add(mesh:FlxMesh) {
		members.push(mesh);
	}
}
