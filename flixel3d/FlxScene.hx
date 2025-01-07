package flixel3d;

/**
 * This is used to have a optimized way of rendering multiple models at once,
 * and without having each model be layered, but instead being rendered as a single entity.
**/
class FlxScene extends FlxSprite {
	public var models:Array<FlxModel>;

	// public var view:ViewBitmapData;

	public function new(width:Int, height:Int) {
		// view = new ViewBitmapData(width, height);
		// loadGraphic(view);
	}

	override public function draw():Void {}
}
