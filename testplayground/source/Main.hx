package;

import flixel3d.FlxG3D;
import flixel.FlxG;
import openfl.display.FPS;
import flixel.FlxGame;
import flixel3d.FlxG3D;
import openfl.display.Sprite;
import openfl.display3D.Context3D;

import flixel3d.system.frontEnds.MeshFrontEnd;

class Main extends Sprite
{
	var context:Context3D;
	public function new()
	{
		super();
		//FlxG3D.mesh
		//addChild(new FlxGame(0, 0, PlayState)); 
		//FlxG3D.init(function() { 
			addChild(new FlxGame(0, 0, TestState2, 60, 60, true)); 
		//});

		addChild(new FPS(10, 10, 0xFFFFFF));

		FlxG.updateFramerate = FlxG.drawFramerate = 240;
		FlxG.autoPause = false;
		
	}
}
