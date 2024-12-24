package flixel3d;

import openfl.display.Bitmap;

class ViewBitmap extends Bitmap {
	private var __data:ViewBitmapData;

	public function new(width:Int, height:Int) {
		__data = new ViewBitmapData(width, height);
		super(__data);
	}

	public function render() {
		__data.render();
	}
}
