package flixel3d;

import flixel.FlxSprite;
import haxe.exceptions.NotImplementedException;

/**
 * A surface is a 2D plane that can be used to put FlxSprites on.
 * The collection is like a FlxGroup.
 */
@:haxe.warning("This class is not implemented and will throw a NotImplementedException if created.")
class Flx3DSurface {
	public var members:Array<FlxSprite>;

	public function new() {
		throw new NotImplementedException();
	}

	public function add(sprite:FlxSprite) {
		members.push(sprite);
	}

	public function remove(sprite:FlxSprite) {
		members.remove(sprite);
	}

	public function clear() {
		members = [];
	}
}
