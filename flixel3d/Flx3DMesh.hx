package flixel3d;

import flixel3d.Flx3DMeshData;
import flixel3d.materials.IFlx3DMaterial;
import flixel3d.materials.Flx3DTestMaterial;

class Flx3DMesh {
	// public var id:String = "";
	public var material:IFlx3DMaterial;
	public var data:Flx3DMeshData;

	public function new(data:Flx3DMeshData) {
		this.data = data;
		material = new Flx3DTestMaterial();
	}
	/*@:deprecated public static function fromAssetKey(source:String, unique:Bool = false, ?key:String, cache:Bool = true, ?format:Flx3DMeshFormat):Flx3DMesh {
			return new Flx3DMesh(Flx3DMeshData.fromAssetKey(source, unique, key, cache, format));
		}

		@:deprecated public static function fromBytes(data:haxe.io.Bytes, format:Flx3DMeshFormat, unique:Bool = false, ?key:String, cache:Bool = true):Flx3DMeshData {
			throw new NotImplementedException();
		}

		@:deprecated public static function fromArray(vertexData:Array<Float>, elementData:Array<UInt>):Flx3DMeshData {
			return new Flx3DMesh(Flx3DMeshData.fromArray(vertexData, elementData));
	}*/
}
