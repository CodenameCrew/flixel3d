package flixel3d;

import lime.graphics.WebGLRenderContext;
import flixel.FlxG;
import openfl.display3D.Context3D;
import haxe.Exception;
import openfl.events.Event;
import flixel3d.system.frontEnds.MeshFrontEnd;
import lime.graphics.opengl.GL;

/*
	Global helper class, like FlxG, but for 3d-related properties such as mesh loading
 */
@:access(openfl.display3D.Context3D)
class FlxG3D {
	public static var context3D(get, null):Context3D;
	public static var gl(get, null):WebGLRenderContext;
	public static var glVersion(get, null):String;

	public static var mesh:MeshFrontEnd = new MeshFrontEnd();

	public static function get_context3D() {
		return FlxG.stage.context3D;
	}

	public static function get_gl() {
		return context3D.gl;
	}

	public static function get_glVersion() {
		#if desktop
		return GL.getString(GL.VERSION);
		#end
		return "";
	}
	/*public static function init(initCallback:() -> Void) {
		initCallback();
		/*if (FlxG.stage.stage3Ds.length > 0) {
				var stage3D = FlxG.stage.stage3Ds[0];
				stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(event:Event) {
					context3D = stage3D.context3D;
					initCallback();
				});
				stage3D.requestContext3D();
			} else {
				throw new Exception("No Stage3D instances found.");
		}* /
	}*/
}
