package flixel3d;

import lime.utils.Float32Array;
import flixel3d.views.Flx3DViewBuffer;

interface IFlx3DDrawable {
	private var views:Array<Flx3DViewBuffer>;
	public function getTransformMatrix():Float32Array;
	public var color:FlxColor;
	public var meshes:Array<FlxMesh>;
}
