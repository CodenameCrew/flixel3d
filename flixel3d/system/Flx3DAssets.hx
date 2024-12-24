package flixel3d.system;
import lime.utils.ArrayBufferView;
import haxe.io.Bytes;
import flixel.util.typeLimit.OneOfTwo;
import flixel.util.typeLimit.OneOfThree;

typedef FlxMeshAsset = OneOfTwo<String, Bytes>;


/**
 * Enum representing a model format.
 * Currently the only suppported format is Wavefront OBJ.
 */
enum FlxMeshFormat
{
    OBJ;
    FBX;
    RAW;
}