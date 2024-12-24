package flixel3d;

import openfl.display.Bitmap;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel3d.FlxSupersampling;

@:access(RenderBitmap)
class FlxCamera3D extends FlxCamera {
	var supersampling:FlxSupersampling;
	var __bitmap3D:ViewBitmap;
}
