package flixel3d;

import lime.graphics.PixelFormat;
import openfl.display.BitmapData;
import lime.graphics.opengl.GLTexture;
import lime.graphics.Image;
import openfl.Assets;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/*var view = new lime.utils.UInt8Array(4);
	view[0] = 246;
	view[1] = 136;
	view[2] = 31;
	view[3] = 255;
	ljTexture = gl.createTexture();
	gl.bindTexture(gl.TEXTURE_2D, ljTexture);
	// gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, ljImage.width, ljImage.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, ljImage.data);
	gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, view);
	gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
	gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
	gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
	gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
 */
class FlxTexture implements IFlxDestroyable {
	private static var cache:Map<String, FlxTexture>;

	public static var defaultTexture:FlxTexture;

	private function new() {
		cache = new Map<String, FlxTexture>();
	}

	private var __glTexture:GLTexture;

	public static function fromFile(file:String, ?key:String) {
		return fromImage(Image.fromFile(file), key);
	}

	public static function fromBitmapData(data:BitmapData, ?key:String) {
		return fromImage(Image.fromBitmapData(data), key);
	}

	public static function fromAssetKey(asset:String, ?key:String) {
		if (key == null)
			key = asset;
		return fromBitmapData(Assets.getBitmapData(asset), key);
	}

	public static function fromImage(image:Image, ?key:String) {
		var tex = new FlxTexture();
		image.format = PixelFormat.RGBA32;

		var gl = FlxG3D.gl;
		tex.__glTexture = gl.createTexture();
		gl.bindTexture(gl.TEXTURE_2D, tex.__glTexture);
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, image.width, image.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, image.data);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
		// gl.bindTexture(gl.TEXTURE_2D, 0);

		if (key != null)
			cache.set(key, tex);

		return tex;
	}

	public function destroy() {
		var gl = FlxG3D.gl;
		gl.deleteTexture(__glTexture);
	}
}
