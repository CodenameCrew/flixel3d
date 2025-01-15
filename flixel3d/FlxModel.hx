package flixel3d;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.typeLimit.OneOfThree;
import flixel3d.math.FlxPoint3D;
import flixel3d.loaders.BaseLoader;
import flixel3d.loaders.FbxLoader;
import flixel3d.loaders.ObjLoader;
import flixel3d.system.Flx3DAssets.FlxMeshFormat;
import lime.utils.Float32Array;
import flixel.util.FlxColor;
import flixel3d.math.MatrixUtil;

/**
 * This is a sprite which renders a single 3d model,
 * if combined with the FlxScene class, it can be used to render multiple models at once.
 * This class makes it so you can render a single object and layer it on top of another object.
 * FlxModels do not appear on regular `FlxCamera`s, only `FlxCamera3D`s.
 *
 * Dev note: im not sure if i should use FlxSprite or FlxBasic here
**/
class FlxModel extends FlxObject3D {
	private var mx:Float32Array;

	public var color:FlxColor = 0xFFFFFFFF;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		mx = new Float32Array(16);
		super(x, y, z);
	}

	public function getTransformMatrix():Float32Array {
		return MatrixUtil.calculateTransform(this);
	}

	public var meshes:Array<FlxMesh>;

	/**
	 * Data can be either a path, a haxe.io.Bytes class of the data or an existing FlxMesh instance.
	**/
	public function loadMesh(data:OneOfThree<String, haxe.io.Bytes, flixel3d.FlxMesh>, ?texture:FlxGraphicAsset, ?format:FlxMeshFormat):FlxModel {
		// possibly add functionality to destroy previous meshes if they are not used?
		meshes = [];
		return addMesh(data, texture, format);
	}

	public function addMesh(data:OneOfThree<String, haxe.io.Bytes, flixel3d.FlxMesh>, ?texture:FlxGraphicAsset, ?format:FlxMeshFormat) {
		if (Std.isOfType(data, String)) {
			meshes.push(FlxMesh.fromAssetKey(data, false, null, true, format));
		} else if (Std.isOfType(data, haxe.io.Bytes)) { // loading from bytes is not properly implemented if at all, don't use this
			meshes.push(FlxMesh.fromBytes(data, format));
		} else {
			meshes.push(data);
		}
		return this;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
	}

	public override function draw() {
		for (cam in cameras) {
			if (Std.isOfType(cam, FlxCamera3D)) {
				var cam3D:FlxCamera3D = cast cam;
				cam3D.addToRenderQueue(this);
			}
		}
	}
}
