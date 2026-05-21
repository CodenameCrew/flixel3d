package flixel3d.materials;

import haxe.exceptions.NotImplementedException;
import flixel3d.materials.Flx3DBaseMaterial;
import lime.graphics.opengl.GLProgram;
import lime.graphics.WebGLRenderContext;

/**
 * Flx3DStandardMaterial is the standard material.
 *
 * It's not finished yet, so for now use `Flx3DLegacyMaterial`.
 */
class Flx3DStandardMaterial extends Flx3DBaseMaterial {
	public function setAlbedoMap() {}

	private function applyGL(gl:WebGLRenderContext):GLProgram {
		throw new NotImplementedException();
	}
}
