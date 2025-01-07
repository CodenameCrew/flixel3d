package flixel3d.loaders;

import flixel.util.typeLimit.OneOfTwo;
import haxe.io.BytesInput;
import openfl.Assets;
import openfl.utils.ByteArray;

class BaseLoader {
	public var format:String;
	public var data:BytesInput;

	private var meshes:Array<FlxMesh>;

	/*
		public var vertexCount(default, null):UInt = 0;
		public var vertexCoords:ByteArray;

		public var normalCount(default, null):UInt = 0;
		public var normalCoords:ByteArray;

		public var textureCount(default, null):UInt = 0;
		public var textureCoords:ByteArray; 
	 */
	public var vertexCoords:Array<Array<Float>>;
	public var normalCoords:Array<Array<Float>>;
	public var textureCoords:Array<Array<Float>>;

	public var elementCount(default, null):UInt = 0;
	public var elementBuffer:ByteArray;

	public var vertexCount(default, null):UInt = 0;
	public var vertexBuffer:ByteArray;

	public var vertexArray:Array<Float>;
	public var elementArray:Array<UInt>;

	public function new(format:String) {
		this.format = format;
		// vertexBuffer = new ByteArray();
		// elementBuffer = new ByteArray();
	}

	/**
	 * Parses the .obj file and its .
	 * Throws an exception if invalid data is detected.
	**/
	public function load(data:OneOfTwo<String, haxe.io.Bytes>):FlxMesh {
		vertexCoords = [];
		normalCoords = [];
		textureCoords = [];
		meshes = [];
		// vertexBuffer.clear();
		// elementBuffer.clear();
		vertexArray = [];
		elementArray = [];

		if ((data is String))
			data = Assets.getBytes(data);
		this.data = new BytesInput(data);

		return null;
	}
}
