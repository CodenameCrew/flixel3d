package flixel3d;

import flixel3d.Flx3DGeometry;
import flixel3d.materials.Flx3DBaseMaterial;
import flixel3d.materials.Flx3DLegacyMaterial;

/**
 * An Flx3DMesh is an instance of `Flx3DGeometry` with an `Flx3DBaseMaterial` associated with it.
 */
class Flx3DMesh {
	public var material:Flx3DBaseMaterial;
	public var data:Flx3DGeometry;

	public function new(data:Flx3DGeometry) {
		this.data = data;
		material = new Flx3DLegacyMaterial();
	}
}
