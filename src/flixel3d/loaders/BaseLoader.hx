package flixel3d.loaders;

import flixel.util.typeLimit.OneOfTwo;
import haxe.io.BytesInput;
import openfl.Assets;
import openfl.utils.ByteArray;

/**
 * The base class for loading models
 */
class BaseLoader {
	public var format:String;
	public var data:BytesInput;

	public var meshes:Map<String, Flx3DGeometry>;

	public var vertexCoords:Array<Array<Float>>;
	public var normalCoords:Array<Array<Float>>;
	public var textureCoords:Array<Array<Float>>;

	public var vertexArray:Array<Float>;
	public var elementArray:Array<UInt>;

	private var vertexCount:UInt = 0;

	public function new(format:String) {
		this.format = format;
	}

	/**
	 * The base loading functionality.
	 */
	public function load(data:OneOfTwo<String, haxe.io.Bytes>):Map<String, Flx3DGeometry> {
		meshes = new Map<String, Flx3DGeometry>();
		vertexCoords = [];
		normalCoords = [];
		textureCoords = [];
		meshes = [];
		vertexArray = [];
		elementArray = [];

		vertexCount = 0;

		if ((data is String))
			data = Assets.getBytes(data);
		this.data = new BytesInput(data);

		return null;
	}
}
