package flixel3d.shading;

import openfl.Assets;
import flixel3d.shading.FlxShader3D;
import flixel3d.system.Flx3DAssets.FlxTextureAsset;
import openfl.display.BitmapData;
import haxe.exceptions.NotImplementedException;
import flixel.util.FlxColor;

/**
 * WIP
 */
@:allow(flixel3d.render.ViewBitmap)
class FlxMaterial {
	private var __shader:FlxShader3D;

	public var color:FlxColor = FlxColor.WHITE;

	public var textures:Array<FlxTexture>;

	/**
	 * A helper for setting the main texture.
	 */
	public function setTexture(texture:FlxTextureAsset, ?key:String):FlxMaterial {
		var newTexture:FlxTexture = getTexture(texture, key);

		if (textures.length > 0)
			textures[0] = newTexture;
		else
			textures.push(newTexture);
		return this;
	}

	private function getTexture(texture:FlxTextureAsset, ?key:String):FlxTexture {
		var newTexture:FlxTexture;
		if (Std.isOfType(texture, String)) {
			newTexture = FlxTexture.fromAssetKey(texture, key);
		} else if (Std.isOfType(texture, BitmapData)) {
			newTexture = FlxTexture.fromBitmapData(texture, key);
		} else {
			throw new NotImplementedException();
		}
		return newTexture;
	}

	public function addTexture(texture:FlxTextureAsset, ?key:String):FlxMaterial {
		var newTexture:FlxTexture = getTexture(texture, key);
		textures.push(newTexture);
		return this;
	}

	public function insertTexture(index:UInt, texture:FlxTextureAsset, ?key:String):FlxMaterial {
		var newTexture:FlxTexture = getTexture(texture, key);
		textures.insert(index, newTexture);
		return this;
	}

	public function new() {
		textures = [];
		__shader = FlxShader3D.defaultShader;
		/*new FlxShader3D(
				Assets.getText("assets/shaders/default.frag"),
				Assets.getText("assets/shaders/default.vert")
			); */
	}
}
