package flixel3d.materials;

import haxe.exceptions.NotImplementedException;
import flixel3d.materials.IFlx3DMaterial;
import lime.graphics.opengl.GLProgram;
import lime.graphics.WebGLRenderContext;

/**
 * Flx3DStandardMaterial is the standard material.
 *
 * It's not finished yet, so for now use `Flx3DLegacyMaterial`.
 */
class Flx3DStandardMaterial implements IFlx3DMaterial {
	public function setAlbedoMap() {}

	private function applyGL(gl:WebGLRenderContext):GLProgram {
		throw new NotImplementedException();
	}
}
