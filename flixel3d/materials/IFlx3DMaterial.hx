package flixel3d.materials;

import flixel3d.shading.FlxShader3D;
import lime.graphics.opengl.GLProgram;
import lime.graphics.WebGLRenderContext;

interface IFlx3DMaterial {
	/*private var _shader:FlxShader3D = null;
		private var _textures:Array<Flx3DTexture>;

		public function new() {
			_textures = new Array<Flx3DTexture>();
			_shader = new FlxShader3D("", FlxShader3D.DEFAULT_VERTEX);
	}*/
	public function applyGL(gl:WebGLRenderContext):GLProgram;
}
