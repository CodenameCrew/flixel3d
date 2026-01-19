package flixel3d;

import haxe.io.Float32Array;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel3d.FlxSupersampling;
import flixel3d.render.ViewBitmap;
import flixel3d.render.SSAAShader;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import lime.utils.Float32Array;
import flixel3d.math.MatrixUtil;
import openfl.display.Sprite;
import flixel3d.views.Flx3DViewBuffer;

/**
 * 3D camera camera controls for a view.
 * Generally does not need to be instantiated manually, as it is automatically added to each view, which only supports a single camera at a time.
**/
class Flx3DCamera extends Flx3DObject {
	public var fov:Float;

	private var mx:Float32Array;

	public function new(fov:Float = 90) {
		super();
		this.fov = fov;

		mx = new Float32Array(16);
	}

	public function getPerspectiveMatrix():Float32Array {
		return MatrixUtil.perspective(this);
	}

	public function getTransformMatrix():Float32Array {
		return MatrixUtil.calculateTransform(this, mx, true);
	}
}
