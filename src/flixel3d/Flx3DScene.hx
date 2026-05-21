package flixel3d;

import flixel3d.internal.Flx3DSceneContainer;
import flixel3d.Flx3DCamera;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel3d.render.Flx3DRenderBuffer;

/**
 * Flx3DScene is an FlxSprite which a 3D scene is rendered onto.
 * This is the main way to use Flixel3D.
 */
class Flx3DScene extends FlxSprite implements IFlx3DScene {
	private var buffer(default, null):Flx3DRenderBuffer;

	/**
	 * The 3D scene's camera.
	 */
	public var camera3D(get, set):Flx3DCamera;

	public inline function get_camera3D()
		return buffer.camera3D;

	public inline function set_camera3D(value:Flx3DCamera)
		return buffer.camera3D = value;

	/**
	 * The 3D scene's clear colour.
	 */
	public var bgColor(get, set):FlxColor;

	public function get_bgColor()
		return buffer.bgColor;

	public function set_bgColor(value:FlxColor)
		return buffer.bgColor = value;

	/**
	 * An FlxContainer containing all of the objects in the scene. (Dev note: should this be renamed?)
	 */
	public var objects(get, null):Flx3DSceneContainer;

	public inline function get_objects()
		return buffer.objects;

	/**
	 * @param   x   		The initial X position of the sprite.
	 * @param   y   		The initial Y position of the sprite.
	 * @param   width   	Desired width of the framebuffer.
	 * @param   height   	Desired height of the framebuffer.
	 * @param   maxSize  	Maximum amount of members allowed in the objects group.
	 */
	public function new(x:Float = 0, y:Float = 0, width:Int = -1, height:Int = -1, maxSize:Int = 0) {
		super(x, y);
		buffer = new Flx3DRenderBuffer(width, height, maxSize);
		loadGraphic(buffer);
	}

	/**
	 * Changes the size of the view.
	 */
	public function resize(width:Int, height:Int) {
		buffer.resize(width, height);
	}

	override function update(elapsed:Float) {
		buffer.update(elapsed);
		super.update(elapsed);
	}

	/**
	 * Automatically goes through and calls render on everything you added.
	 */
	override function draw() {
		buffer.render();
		super.draw();
	}

	override function destroy() {
		buffer.dispose();
		super.destroy();
	}
}

interface IFlx3DScene {
	/**
	 * The 3D scene's camera.
	 */
	public var camera3D(get, set):Flx3DCamera;

	/**
	 * An FlxContainer containing all of the objects in the scene. (Dev note: should this be renamed?)
	 */
	public var objects(get, null):Flx3DSceneContainer;

	/**
	 * The 3D scene's clear colour.
	 */
	public var bgColor(get, set):FlxColor;
}
