package flixel3d.render;

import flixel.util.FlxColor;
import openfl.display3D.textures.RectangleTexture;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.WebGLRenderContext;
import flixel3d.FlxG3D;
import openfl.display.BitmapData;
import lime.graphics.opengl.GL;

// glGet(GL_DRAW_FRAMEBUFFER_BINDING)

/**
 * ViewBitmapData represents the texture which is used as the render target
**/
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(flixel3d.FlxMesh)
@:access(flixel3d.shading.FlxMaterial)
@:access(flixel3d.shading.FlxShader3D)
@:access(flixel3d.FlxTexture)
class ViewBitmapData extends BitmapData {
	var __renderTarget:RectangleTexture;

	public function new(width:Int, height:Int) {
		super(width, height, true, 0);
		readable = false;
		image = null;
		resize(width, height);
	}

	public function resize(width:Int, height:Int) {
		if (__texture != null)
			__texture.dispose();
		__texture = FlxG3D.context3D.createRectangleTexture(width, height, BGRA, true);
		__textureContext = __texture.__textureContext;
	}

	public function setRenderToTexture() {
		FlxG3D.context3D.setRenderToTexture(__texture);
	}

	private function flush() {
		FlxG3D.context3D.__flushGLFramebuffer();
		FlxG3D.context3D.__flushGLViewport();
	}

	private function clear(gl:WebGLRenderContext, color:FlxColor) {
		gl.colorMask(true, true, true, true);
		gl.clearColor(color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat);
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

	public function render(models:Array<FlxModel>, clearColor:FlxColor = 0xFF000000) {
		var gl:WebGLRenderContext = FlxG3D.gl;
		setRenderToTexture();
		flush();

		// gl.activeTexture(gl.TEXTURE0);
		// gl.bindTexture(gl.TEXTURE_2D, ljTexture);
		var maxTextureUnits:Int = gl.getParameter(gl.MAX_COMBINED_TEXTURE_IMAGE_UNITS);
		var preRenderCaps = [for (cap in capabilities) gl.isEnabled(cap)];
		var depthFuncOld = gl.getParameter(gl.DEPTH_FUNC);
		for (cap in capabilities)
			gl.enable(cap);

		gl.depthMask(false);
		gl.depthFunc(depthFunc);

		// Clear
		clear(gl, clearColor);

		for (model in models) {
			for (mesh in model.meshes) {
				if (mesh.material.textures.length != 0) {
					for (i in 0...mesh.material.textures.length) {
						if (i < maxTextureUnits) {
							gl.activeTexture(gl.TEXTURE0 + i);
							gl.bindTexture(gl.TEXTURE_2D, mesh.material.textures[i].__glTexture);
						}
					}
				} else {
					gl.activeTexture(gl.TEXTURE0);
					gl.bindTexture(gl.TEXTURE_2D, FlxTexture.defaultTexture.__glTexture);
				}
				// Shader
				var program:GLProgram = mesh.material.__shader.__glProgram;
				gl.useProgram(program);
				var uTransform = gl.getUniformLocation(program, "uTransform");
				gl.uniformMatrix4fv(uTransform, false, model.getTransformMatrix());

				var color = model.color;
				var uColor = gl.getUniformLocation(program, "uColor");
				gl.uniform4f(uColor, color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat);

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
	/*
		instancing wip

		var uniqueMeshes:Array<FlxMesh> = new Array<FlxMesh>();
		// var meshes:Array<FlxMesh> = new Array<FlxMesh>();
		for (mesh in meshes) {
			if (mesh.__instanceCount == 0) {
				uniqueMeshes.push(mesh);
			}
			mesh.__instanceCount++;
		}
		var iPosition:GLUniformLocation = gl.getUniformLocation(program, "iPosition");

		// 32767 instance limit per draw call? or smaller?
		// if instance count exceeds limit (in that case what the actual fuck are you doing), put them in another draw call
		for (mesh in uniqueMeshes) {
			var instanceCount:Int = mesh.__instanceCount;

			while (instanceCount > 0) {
				gl.uniform3fv(iPosition, positions);
				gl.drawElementsInstanced(gl.TRIANGLES, mesh.__elementCount, gl.UNSIGNED_SHORT, 0, Math.min(instanceCount, 32767));
				instanceCount -= 32767;
			}

			mesh.__instanceCount = 0;
	}*/
}
