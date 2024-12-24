package flixel3d;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;

@:access(openfl.display3D.Context3D)
class FlxShader3D {
	var __glProgram:GLProgram;

	public function new(fragmentSource:String, vertexSource:String) {
		__glProgram = GLProgram.fromSources(FlxG3D.context3D.gl, fragmentSource, vertexSource);
	}
}
