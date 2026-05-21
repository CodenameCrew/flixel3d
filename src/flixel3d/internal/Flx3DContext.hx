package flixel3d.internal;

import lime.graphics.WebGLRenderContext;
import flixel.FlxG;
import openfl.display3D.Context3D;
import lime.graphics.opengl.GL;

class Flx3DContext {
	public static var context3D(get, null):Context3D;
	public static var gl(get, null):WebGLRenderContext;
	public static var glVersion(get, null):String;

	@:dox(hide) public static inline function get_context3D() {
		return FlxG.stage.context3D;
	}

	@:dox(hide) public static inline function get_gl() {
		@:privateAccess return context3D.gl;
	}

	@:dox(hide) public static inline function get_glVersion() {
		#if desktop
		return GL.getString(GL.VERSION);
		#end
		return "";
	}
}
