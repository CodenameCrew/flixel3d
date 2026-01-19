package flixel3d.shading;

import openfl.Assets;
import flixel3d.shading.FlxShader3D;
import flixel3d.system.Flx3DAssets.Flx3DTextureAsset;
import openfl.display.BitmapData;
import haxe.exceptions.NotImplementedException;
import flixel.util.FlxColor;

/**
 * WIP
 */
@:deprecated
@:allow(flixel3d.render.ViewBitmap)
class FlxMaterial {
	private var __shader:FlxShader3D;

	public var color:FlxColor = FlxColor.WHITE;

	public var textures:Array<Flx3DTexture>;

	/**
	 * A helper for setting the main texture.
	 */
	public function setTexture(texture:Flx3DTextureAsset, ?key:String):FlxMaterial {
		var newTexture:Flx3DTexture = getTexture(texture, key);

		if (textures.length > 0)
			textures[0] = newTexture;
		else
			textures.push(newTexture);
		return this;
	}

	private function getTexture(texture:Flx3DTextureAsset, ?key:String):Flx3DTexture {
		var newTexture:Flx3DTexture;
		if (Std.isOfType(texture, String)) {
			newTexture = Flx3DTexture.fromAssetKey(texture, key);
		} else if (Std.isOfType(texture, BitmapData)) {
			newTexture = Flx3DTexture.fromBitmapData(texture, key);
		} else {
			throw new NotImplementedException();
		}
		return newTexture;
	}

	public function addTexture(texture:Flx3DTextureAsset, ?key:String):FlxMaterial {
		var newTexture:Flx3DTexture = getTexture(texture, key);
		textures.push(newTexture);
		return this;
	}

	public function insertTexture(index:UInt, texture:Flx3DTextureAsset, ?key:String):FlxMaterial {
		var newTexture:Flx3DTexture = getTexture(texture, key);
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
