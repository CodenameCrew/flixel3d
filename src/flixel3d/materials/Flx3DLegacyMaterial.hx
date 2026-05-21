package flixel3d.materials;

import flixel3d.materials.IFlx3DMaterial;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.WebGLRenderContext;
import flixel3d.shading.FlxShader3D;
import flixel.util.FlxColor;
import flixel3d.system.Flx3DAssets.Flx3DTextureAsset;
import openfl.display.BitmapData;
import haxe.exceptions.NotImplementedException;

/**
 * A temporary implementation of the deprecated FlxMaterial class in the new material system.
 * This will be removed in the future.
 */
@:deprecated("Will be removed once Flx3DStandardMaterial is ready for use.")
class Flx3DLegacyMaterial implements IFlx3DMaterial {
	private var __shader:FlxShader3D;

	public var color:FlxColor = FlxColor.WHITE;

	public var textures:Array<Flx3DTexture>;

	private function applyGL(gl:WebGLRenderContext):GLProgram @:privateAccess {
		var program:GLProgram = __shader.__glProgram;
		gl.useProgram(program);

		var maxTextureUnits:Int = gl.getParameter(gl.MAX_COMBINED_TEXTURE_IMAGE_UNITS);

		// Shader
		if (textures.length != 0) {
			for (i in 0...textures.length) {
				if (i < maxTextureUnits) {
					gl.activeTexture(gl.TEXTURE0 + i);
					gl.bindTexture(gl.TEXTURE_2D, textures[i].__glTexture);
				}
			}
		} else {
			gl.activeTexture(gl.TEXTURE0);
			gl.bindTexture(gl.TEXTURE_2D, Flx3DTexture.defaultTexture.__glTexture);
		}

		/*var modelColor = model.color;
			var uModelColor = gl.getUniformLocation(program, "uModelColor");
			gl.uniform4f(uModelColor, modelColor.redFloat, modelColor.greenFloat, modelColor.blueFloat, modelColor.alphaFloat);
		 */
		var uColor = gl.getUniformLocation(program, "uColor");
		gl.uniform4f(uColor, color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat);

		return program;
	}

	/**
	 * A helper for setting the main texture.
	 */
	public function setTexture(texture:Flx3DTextureAsset, ?key:String):Flx3DLegacyMaterial {
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

	public function addTexture(texture:Flx3DTextureAsset, ?key:String):Flx3DLegacyMaterial {
		var newTexture:Flx3DTexture = getTexture(texture, key);
		textures.push(newTexture);
		return this;
	}

	public function insertTexture(index:UInt, texture:Flx3DTextureAsset, ?key:String):Flx3DLegacyMaterial {
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
