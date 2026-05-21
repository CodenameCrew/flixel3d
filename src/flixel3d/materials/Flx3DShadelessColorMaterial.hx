package flixel3d.materials;

import haxe.exceptions.NotImplementedException;
import flixel3d.shading.FlxShader3D;
import lime.graphics.opengl.GLProgram;
import lime.graphics.WebGLRenderContext;
import flixel.util.FlxColor;

/**
 * A color material unaffected by shading and lighting.
 */
class Flx3DShadelessColorMaterial extends Flx3DBaseMaterial {
	var __shader:FlxShader3D;

	/**
	 * The color of the material.
	 */
	public var color:FlxColor;

	/**
	 * @param color	The initial color of the material.
	 */
	public function new(color:FlxColor = 0xFFFFFFFF) {
		this.color = color;
		__shader = FlxShader3D.defaultShader;
	}

	private function applyGL(gl:WebGLRenderContext):GLProgram {
		var program:GLProgram = @:privateAccess __shader.__glProgram;
		gl.useProgram(program);

		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, @:privateAccess Flx3DTexture.defaultTexture.__glTexture);

		var uColor = gl.getUniformLocation(program, "uColor");
		gl.uniform4f(uColor, color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat);

		return program;
	}
}
