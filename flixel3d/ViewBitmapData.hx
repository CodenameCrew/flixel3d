package flixel3d;

import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.WebGLRenderContext;
import flixel3d.FlxG3D;
import openfl.display.BitmapData;

// glGet(GL_DRAW_FRAMEBUFFER_BINDING)

@:struct class MeshPosition {
	public var mesh:FlxMesh;
	public var transform:FlxTransform;
}

/**
 * ViewBitmapData represents the texture which is used
**/
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(flixel3d.FlxMesh)
class ViewBitmapData extends BitmapData {
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

	public function setRenderToBackBuffer() {
		FlxG3D.context3D.setRenderToBackBuffer();
	}

	public function render() {
		var gl:WebGLRenderContext = FlxG3D.gl;
		var uniqueMeshes:Array<FlxMesh> = new Array<FlxMesh>();
		// var meshes:Array<FlxMesh> = new Array<FlxMesh>();
		var models:Array<FlxModel> = new Array<FlxModel>();
		for (model in models) {
			for (mesh in model.meshes) {
				if (mesh.__instanceCount == 0) {
					uniqueMeshes.push(mesh);
				}
				mesh.__instanceCount++;
			}
		}
		var iPosition:GLUniformLocation = gl.getUniformLocation(program, "iPosition");

		// 32767 instance limit per draw call? or smaller?
		// if instance count exceeds limit (in that case what the actual fuck are you doing), put them in another draw call
		for (mesh in uniqueMeshes) {
			var instanceCount:Int = mesh.__instanceCount;

			while (instanceCount > 0) {
				gl.uniform3fv(iPosition, positions);
				gl.drawElementsInstanced(gl.TRIANGLES, mesh.__indexCount, gl.UNSIGNED_SHORT, 0, Math.min(instanceCount, 32767));
				instanceCount -= 32767;
			}

			mesh.__instanceCount = 0;
		}
	}
}
