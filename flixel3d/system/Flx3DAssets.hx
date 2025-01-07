package flixel3d.system;

import lime.utils.ArrayBufferView;
import haxe.io.Bytes;
import flixel.util.typeLimit.OneOfTwo;
import flixel.util.typeLimit.OneOfThree;
import flixel.util.typeLimit.OneOfFour;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

typedef FlxMeshAsset = OneOfTwo<String, Bytes>;
typedef FlxTextureAsset = OneOfFour<FlxGraphic, BitmapData, String, FlxTexture>;

/**
 * Enum representing a model format.
 * Currently the only suppported format is Wavefront OBJ.
 */
enum FlxMeshFormat {
	OBJ;
	FBX;
	RAW;
}
