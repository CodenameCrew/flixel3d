package flixel3d;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.typeLimit.OneOfThree;
import flixel3d.math.Flx3DPoint;
import flixel3d.loaders.BaseLoader;
import flixel3d.loaders.FbxLoader;
import flixel3d.loaders.ObjLoader;
import flixel3d.system.Flx3DAssets.Flx3DMeshFormat;
import lime.utils.Float32Array;
import flixel.util.FlxColor;
import flixel3d.render.Flx3DRenderBuffer;

/**
 * This is a sprite which renders a single 3d model,
 * if combined with the FlxScene class, it can be used to render multiple models at once.
 * This class makes it so you can render a single object and layer it on top of another object.
 * Flx3DModels do not appear on regular `FlxCamera`s, only `FlxCamera3D`s.
 */
class Flx3DSkeletalModel extends Flx3DModel {}
