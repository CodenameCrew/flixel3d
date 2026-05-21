package flixel3d;

import flixel3d.Flx3DGeometry;
import flixel3d.materials.IFlx3DMaterial;
import flixel3d.materials.Flx3DLegacyMaterial;

/**
 * An Flx3DMesh is an instance of `Flx3DGeometry` with an `IFlx3DMaterial` associated with it.
 */
class Flx3DMesh {
	// public var id:String = "";
	public var material:IFlx3DMaterial;
	public var data:Flx3DGeometry;

	public function new(data:Flx3DGeometry) {
		this.data = data;
		material = new Flx3DLegacyMaterial();
	}
	/*@:deprecated public static function fromAssetKey(source:String, unique:Bool = false, ?key:String, cache:Bool = true, ?format:Flx3DMeshFormat):Flx3DMesh {
			return new Flx3DMesh(Flx3DGeometry.fromAssetKey(source, unique, key, cache, format));
		}

		@:deprecated public static function fromBytes(data:haxe.io.Bytes, format:Flx3DMeshFormat, unique:Bool = false, ?key:String, cache:Bool = true):Flx3DGeometry {
			throw new NotImplementedException();
		}

		@:deprecated public static function fromArray(vertexData:Array<Float>, elementData:Array<UInt>):Flx3DGeometry {
			return new Flx3DMesh(Flx3DGeometry.fromArray(vertexData, elementData));
	}*/
}
