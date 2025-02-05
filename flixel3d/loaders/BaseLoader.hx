package flixel3d.loaders;

import flixel.util.typeLimit.OneOfTwo;
import haxe.io.BytesInput;
import openfl.Assets;
import openfl.utils.ByteArray;

class BaseLoader {
	public var format:String;
	public var data:BytesInput;

	public var meshes:Map<String, FlxMeshData>;

	public var vertexCoords:Array<Array<Float>>;
	public var normalCoords:Array<Array<Float>>;
	public var textureCoords:Array<Array<Float>>;

	public var vertexArray:Array<Float>;
	public var elementArray:Array<UInt>;

	var vertexCount:UInt = 0;

	public function new(format:String) {
		this.format = format;
		// vertexBuffer = new ByteArray();
		// elementBuffer = new ByteArray();
	}

	/**
	 * Parses the .obj file and its .
	 * Throws an exception if invalid data is detected.
	**/
	public function load(data:OneOfTwo<String, haxe.io.Bytes>):Map<String, FlxMeshData> {
		meshes = new Map<String, FlxMeshData>();
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
