package flixel3d.shading;

import openfl.Assets;
import flixel3d.shading.FlxShader3D;
import flixel3d.system.Flx3DAssets.FlxTextureAsset;
import openfl.display.BitmapData;
import haxe.exceptions.NotImplementedException;

/**
 * WIP
 */
@:allow(flixel3d.render.ViewBitmap)
class FlxMaterial {
	private var __shader:FlxShader3D;

	public var textures:Array<FlxTexture>;

	public function addTexture(texture:FlxTextureAsset, ?key:String):FlxMaterial {
		var newTexture:FlxTexture;
		if (Std.isOfType(texture, String)) {
			newTexture = FlxTexture.fromAssetKey(texture, key);
		} else if (Std.isOfType(texture, BitmapData)) {
			newTexture = FlxTexture.fromBitmapData(texture, key);
		} else {
			throw new NotImplementedException();
		}
		textures.push(newTexture);
		return this;
	}

	public function new() {
		textures = [];
		__shader = new FlxShader3D(
			Assets.getText("assets/shaders/default.frag"),
			Assets.getText("assets/shaders/default.vert")
		);
	}
}
