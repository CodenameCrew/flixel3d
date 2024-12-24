package flixel3d;

import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.WebGLRenderContext;

@:access(flixel3d.FlxMesh)
// this is sort of like a mix between pseudocode and haxe right now
class FlxRenderer3D // name tbd
{
	public function draw() {
		var gl:WebGLRenderContext;
		var uniqueMeshes:Array<FlxMesh> = new Array<FlxMesh>();
		var meshes:Array<FlxMesh> = new Array<FlxMesh>();
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
				gl.drawElementsInstanced(gl.TRIANGLES, mesh.__indexCount, gl.UNSIGNED_SHORT, 0, Math.min(instanceCount, 32767));
				instanceCount -= 32767;
			}

			mesh.__instanceCount = 0;
		}
	}
}
