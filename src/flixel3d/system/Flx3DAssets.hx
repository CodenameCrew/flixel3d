package flixel3d.system;

import lime.utils.ArrayBufferView;
import haxe.io.Bytes;
import flixel.util.typeLimit.OneOfTwo;
import flixel.util.typeLimit.OneOfThree;
import flixel.util.typeLimit.OneOfFour;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

typedef Flx3DMeshAsset = OneOfTwo<String, Bytes>;
typedef Flx3DTextureAsset = OneOfFour<FlxGraphic, BitmapData, String, Flx3DTexture>;

/**
 * Enum representing a model format.
 * Currently the only suppported format is Wavefront OBJ.
 */
enum Flx3DMeshFormat {
	OBJ;
	FBX;
	RAW;
}
