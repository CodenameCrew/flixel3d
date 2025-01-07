package flixel3d;

import openfl.display.BitmapData;
import flixel.util.FlxColor;
import haxe.exceptions.NotImplementedException;
import flixel3d.loaders.BaseLoader;
import flixel3d.loaders.ObjLoader;
import flixel3d.system.Flx3DAssets.FlxMeshFormat;
import flixel3d.FlxG3D;
import haxe.io.UInt16Array;
import flixel3d.FlxG3D;
import lime.utils.DataPointer;
import openfl.utils.ByteArray;
import haxe.io.Float32Array;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.graphics.opengl.GLBuffer;
import flixel.FlxBasic;
import lime.graphics.WebGLRenderContext;
import lime.utils.ArrayBufferView;
import flixel3d.shading.FlxMaterial;
import flixel3d.FlxTexture;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * This is a mesh containing the data used to render an FlxModel.
**/
class FlxMesh implements IFlxDestroyable {
	private var __instanceCount:UInt; // for use in renderer

	public var id:String = "";
	public var key:String = "";

	public var material:FlxMaterial;

	private var __elementBuffer:GLBuffer;
	private var __elementCount:UInt = 0;
	private var __vertexBuffer:GLBuffer;

	public var useCount:Int = 0;

	public var persist:Bool = false;

	public function destroy() {}

	private function new() {
		material = new FlxMaterial();
	}

	public function makeUnique():FlxMesh {
		throw new NotImplementedException();
	}

	private static inline function getFormatFromExtension(path:String) {
		return switch (path.substring(path.lastIndexOf("."))) {
			case '.obj': FlxMeshFormat.OBJ;
			case '.fbx': FlxMeshFormat.FBX;
			default: FlxMeshFormat.RAW;
		}
	}

	public static function fromAssetKey(source:String, unique:Bool = false, ?key:String, cache:Bool = true, ?format:FlxMeshFormat):FlxMesh {
		if (format == null)
			format = getFormatFromExtension(source);
		var loader:BaseLoader;
		switch (format) {
			case FlxMeshFormat.OBJ: loader = new ObjLoader();
			default: throw new NotImplementedException("Wavefront OBJ (.obj) is currently the only supported model format.");
		}
		var loadedMesh = loader.load(source);

		loadedMesh.key = source; // key ?? source;
		FlxG3D.mesh.addMesh(loadedMesh);
		return loadedMesh;
	}

	public static function fromBytes(data:haxe.io.Bytes, format:FlxMeshFormat, unique:Bool = false, ?key:String, cache:Bool = true):FlxMesh {
		throw new NotImplementedException();
	}

	public static function fromArray(vertexData:Array<Float>, elementData:Array<UInt>):FlxMesh {
		var mesh = new FlxMesh();

		mesh.__vertexBuffer = __createArrayBuffer(__haxeArrayToFloat32Array(vertexData));
		mesh.__elementBuffer = __createElementArrayBuffer(__haxeArrayToUInt16Array(elementData));
		mesh.__elementCount = elementData.length;

		return mesh;
	}

	private static function __haxeArrayToFloat32Array(haxeArray:Array<Float>):Float32Array {
		var float32array = new Float32Array(haxeArray.length);
		for (i in 0...haxeArray.length) {
			float32array[i] = haxeArray[i];
		}
		return float32array;
	}

	private static function __haxeArrayToUInt16Array(haxeArray:Array<UInt>):UInt16Array {
		var uint16array = new UInt16Array(haxeArray.length);
		for (i in 0...haxeArray.length) {
			uint16array[i] = haxeArray[i];
		}
		return uint16array;
	}

	private static function __createArrayBuffer(data:ArrayBufferView):GLBuffer {
		var gl:WebGLRenderContext = FlxG3D.gl;
		var buffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
		gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);
		return buffer;
	}

	private static function __createElementArrayBuffer(data:ArrayBufferView):GLBuffer {
		var gl:WebGLRenderContext = FlxG3D.gl;
		var buffer = gl.createBuffer();
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, buffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, data, gl.STATIC_DRAW);
		return buffer;
	}
}
