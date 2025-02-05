package flixel3d.render;

import flixel3d.FlxCamera3D;
import flixel.util.FlxColor;
import openfl.display.Bitmap;
import flixel3d.render.ViewBitmapData;

class ViewBitmap extends Bitmap {
	private var __data:ViewBitmapData;

	public function new(width:Int, height:Int) {
		__data = new ViewBitmapData(width, height);
		super(__data);
	}

	public function render(models:Array<FlxModel>, camera:FlxCamera3D) {
		__data.render(models, camera);
	}

	public function resize(width:Int, height:Int) {
		__data.resize(width, height);
	}

	public function dispose() {
		__data.dispose();
	}
}
