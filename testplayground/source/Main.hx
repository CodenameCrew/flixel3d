package;

import flixel3d.shading.FlxMaterial;
import openfl.display.BitmapData;
import flixel3d.FlxTexture;
import flixel3d.FlxG3D;
import flixel.FlxG;
import openfl.display.FPS;
import flixel.FlxGame;
import flixel3d.FlxG3D;
import openfl.display.Sprite;
import openfl.display3D.Context3D;
import flixel3d.system.frontEnds.MeshFrontEnd;
import openfl.events.UncaughtErrorEvent;
import lime.app.Application;
import openfl.Lib;
import haxe.CallStack;
import haxe.io.Path;

using StringTools;

class Main extends Sprite
{
	var context:Context3D;

	public function new()
	{
		super();
		// FlxG3D.mesh
		// addChild(new FlxGame(0, 0, PlayState));
		// FlxG3D.init(function() {
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		FlxTexture.defaultTexture = FlxTexture.fromBitmapData(new BitmapData(1, 1, 0xFFFFFFFF)); // FlxColor.fromRGB(246, 136, 31)

		addChild(new FlxGame(0, 0, TestState3, 60, 60, true));
		// });

		addChild(new FPS(10, 10, 0xFFFFFF));

		FlxG.updateFramerate = FlxG.drawFramerate = 240;
		FlxG.autoPause = false;
	}

	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					trace(stackItem);
					// Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error;

		Application.current.window.alert(errMsg, "Error!");
	}
}
