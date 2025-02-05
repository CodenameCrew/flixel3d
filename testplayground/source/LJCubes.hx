package;

import flixel3d.FlxMeshData;
import flixel.FlxSprite;
import openfl.display3D.textures.RectangleTexture;
import flixel.FlxState;
import flixel3d.FlxCamera3D;
import flixel3d.FlxModel;
import flixel.FlxG;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel3d.FlxTexture;
import flixel3d.FlxMesh;

class LJCubes extends FlxState
{
	var cam3D:FlxCamera3D;

	var texture:RectangleTexture;
	var haxeArray:Array<FlxModel> = [];
	var haxe2:FlxModel;

	public override function create()
	{
		cam3D = new FlxCamera3D();
		FlxG.cameras.add(cam3D, false);
		cam3D.bgColor = 0xFF00FFFF;

		var d = FlxMeshData.fromAssetKey("assets/models/haxe.obj");
		for (i in 0...10)
		{
			var haxe = new FlxModel().addMesh(new FlxMesh(d));
			haxe.camera = cam3D;
			haxe.z = -10;
			haxe.color = 0xFFF6881F;
			add(haxe);
			haxeArray.push(haxe);
		}

		var ljd = FlxMeshData.fromAssetKey("assets/models/lj.obj");
		var lj = new FlxMesh(ljd);
		lj.material.addTexture("assets/images/itsljcool.png");

		haxe2 = new FlxModel().addMesh(lj);
		haxe2.camera = cam3D;
		haxe2.z = -20;
		add(haxe2);
	}

	var time:Float = 0;

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		haxe2.angleY = Math.sin(-time) * 200; //  += elapsed * 0.5;

		for (i in 1...haxeArray.length + 1)
		{
			var ang = time * i; // (Math.sin(time) * 0.3 + Math.PI) * i;
			var haxe = haxeArray[i - 1];
			haxe.angleY = Math.sin(time) * 180; // += elapsed * i;
			haxe.x = Math.cos(ang) * (2 + i);
			haxe.z = -20 + Math.sin(ang) * (2 + i);
			haxe.y = Math.sin(ang) * (i * 0.5);
		}

		// haxe2.x = Math.cos(time) * 3;
		// haxe2.z = -20 + Math.sin(time) * 3;
		time += elapsed;
		/*haxe2.x = (FlxG.mouse.x / FlxG.width - 0.5) * 2;
			haxe2.y = (FlxG.mouse.y / FlxG.height - 0.5) * 2;
			haxe.x = (FlxG.mouse.x / FlxG.width - 0.5) * 2;
			haxe.y = (FlxG.mouse.y / FlxG.height - 0.5) * 2; */
		// haxe.z -= 0.1;
	}
}
