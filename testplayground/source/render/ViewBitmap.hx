package flixel3d.render;

import openfl.display.Bitmap;
import openfl.display3D.textures.RectangleTexture;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.WebGLRenderContext;
import flixel3d.FlxG3D;
import openfl.display.BitmapData;
import lime.graphics.opengl.GL;

class ViewBitmap extends Bitmap {
	private var __texture:RectangleTexture;

	public function new(width:Int, height:Int) {
		__texture = FlxG3D.context3D.createRectangleTexture(width, height, BGRA, true);
		var data = BitmapData.fromTexture(__texture);
		super(data);
	}

	public function setRenderToTexture() {
		FlxG3D.context3D.setRenderToTexture(__texture);
	}

	@:access(openfl.display3D.Context3D)
	private function flush() {
		FlxG3D.context3D.__flushGLFramebuffer();
		FlxG3D.context3D.__flushGLViewport();
	}

	private function clear(gl:WebGLRenderContext) {
		gl.colorMask(true, true, true, true);
		gl.clearColor(1, 1, 0, 1);
		gl.depthMask(true);
		gl.clearDepth(1);
		gl.stencilMask(0xFF);
		gl.clearStencil(0);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT | gl.STENCIL_BUFFER_BIT);
	}

	public function setRenderToBackBuffer() {
		FlxG3D.context3D.setRenderToBackBuffer();
	}

	var capabilities:Array<Int> = [GL.BLEND, GL.DEPTH_TEST, GL.TEXTURE_2D];

	var depthFunc:Int = GL.LESS;

	@:access(flixel3d.FlxMesh)
	public function render(models:Array<FlxModel>) {
		var gl:WebGLRenderContext = FlxG3D.gl;
		setRenderToTexture();
		flush();

		gl.activeTexture(gl.TEXTURE0);
		// gl.bindTexture(gl.TEXTURE_2D, ljTexture);

		var preRenderCaps = [for (cap in capabilities) gl.isEnabled(cap)];
		var depthFuncOld = gl.getParameter(gl.DEPTH_FUNC);
		for (cap in capabilities)
			gl.enable(cap);

		gl.depthMask(false);
		gl.depthFunc(depthFunc);

		// Clear
		clear(gl);

		for (model in models) {
			for (mesh in model.meshes) {
				// Shader
				var program:GLProgram = mesh.material.__shader.__glProgram;
				gl.useProgram(program);
				var uTransform = gl.getUniformLocation(program, "uTransform");
				gl.uniformMatrix4fv(uTransform, false, model.getTransformMatrix());

				var vPosition:Int = gl.getAttribLocation(program, "vPosition");
				var vColor:Int = gl.getAttribLocation(program, "vColor");
				var vTexCoord:Int = gl.getAttribLocation(program, "vTexCoord");

				// Vertex Buffer
				gl.bindBuffer(gl.ARRAY_BUFFER, mesh.__vertexBuffer);

				// Vertex Position
				gl.vertexAttribPointer(vPosition, 3, gl.FLOAT, false, 32, 0);
				gl.enableVertexAttribArray(0);

				// Vertex Color
				gl.vertexAttribPointer(vColor, 3, gl.FLOAT, false, 32, 12);
				gl.enableVertexAttribArray(1);

				// Vertex Texture Position
				gl.vertexAttribPointer(vTexCoord, 2, gl.FLOAT, false, 32, 24);
				gl.enableVertexAttribArray(2);

				// Draw to framebuffer
				gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, mesh.__elementBuffer);
				gl.drawElements(gl.TRIANGLES, mesh.__elementCount, gl.UNSIGNED_SHORT, 0);
			}
		}

		for (i in 0...capabilities.length) {
			var cap:Int = capabilities[i];
			var value:Bool = preRenderCaps[i];

			if (!value)
				gl.disable(cap);
		}

		gl.depthFunc(depthFuncOld);

		setRenderToBackBuffer();
	}
	/*public function resize(width:Int, height:Int) {
		__data.resize(width, height);
	}*/
}
