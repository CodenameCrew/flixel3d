package flixel3d;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import lime.utils.Float32Array;
import openfl.display.Sprite;
import flixel3d.render.Flx3DRenderBuffer;

/**
 * 3D camera camera controls for a view.
 * Generally does not need to be instantiated manually, as it is automatically added to each view, which only supports a single camera at a time.
**/
class Flx3DCamera extends Flx3DObject {
	public var fov:Float;

	public function new(fov:Float = 90) {
		super();
		this.fov = fov;
		this._ignorePosition = true;
	}
}
