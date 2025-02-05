package flixel3d;

import flixel3d.FlxMeshData;
import flixel3d.shading.FlxMaterial;

class FlxMesh {
	// public var id:String = "";
	public var material:FlxMaterial;
	public var data:FlxMeshData;

	public function new(data:FlxMeshData) {
		this.data = data;
		material = new FlxMaterial();
	}
	/*@:deprecated public static function fromAssetKey(source:String, unique:Bool = false, ?key:String, cache:Bool = true, ?format:FlxMeshFormat):FlxMesh {
			return new FlxMesh(FlxMeshData.fromAssetKey(source, unique, key, cache, format));
		}

		@:deprecated public static function fromBytes(data:haxe.io.Bytes, format:FlxMeshFormat, unique:Bool = false, ?key:String, cache:Bool = true):FlxMeshData {
			throw new NotImplementedException();
		}

		@:deprecated public static function fromArray(vertexData:Array<Float>, elementData:Array<UInt>):FlxMeshData {
			return new FlxMesh(FlxMeshData.fromArray(vertexData, elementData));
	}*/
}
