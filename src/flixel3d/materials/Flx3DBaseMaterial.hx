package flixel3d.materials;

import haxe.exceptions.NotImplementedException;
import flixel3d.shading.FlxShader3D;
import lime.graphics.opengl.GLProgram;
import lime.graphics.WebGLRenderContext;

/**
 * The base class for all materials in Flixel3D.
 */
abstract class Flx3DBaseMaterial {
	private abstract function applyGL(gl:WebGLRenderContext):GLProgram;
}
