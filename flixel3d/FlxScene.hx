package flixel3d;

/**
 * This is used to have a optimized way of rendering multiple models at once,
 * and without having each model be layered, but instead being rendered as a single entity.
**/
class FlxScene extends FlxSprite {
	public var models:Array<FlxModel>;

	public function new() {}

	override public function draw():Void
	{
		
	}
}
