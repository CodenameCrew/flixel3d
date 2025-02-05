package;

import flixel3d.FlxModel;
import flixel.FlxG;
import flixel.FlxState;
import flixel3d.FlxG3D;
import flixel3d.FlxCamera3D;
import flixel3d.FlxMeshData;
import flixel3d.FlxMesh;
import flixel3d.FlxModel;

class PlayState extends FlxState
{
	var cam3D:FlxCamera3D;
	var haxeModel:FlxModel;

	function FlxCube():FlxModel
	{
		var model = new FlxModel();
		model.loadMeshes("assets/models/haxe.obj");
		model.camera = cam3D;
		// trace(haxeModel.meshes);
		add(model);

		model.z = 0;
		model.getMesh("Center").material.color = 0xff00b922;

		model.getMesh("X+TL").material.color = 0xffffc132;
		model.getMesh("X-TL").material.color = 0xffffc132;

		model.getMesh("X+TR").material.color = 0xfff5274e;
		model.getMesh("X-TR").material.color = 0xfff5274e;
		model.getMesh("X+BL").material.color = 0xff3641ff;
		model.getMesh("X-BL").material.color = 0xff3641ff;

		model.getMesh("X+BR").material.color = 0xff04cdfb;
		model.getMesh("X-BR").material.color = 0xff04cdfb;
		return model;
	}

	override function create()
	{
		trace(FlxG3D.glVersion);
		cam3D = new FlxCamera3D();
		FlxG.cameras.add(cam3D, false);

		// haxeModel = FlxCube();
		// haxeModel.z = -1;

		var model = new FlxModel();
		model.loadMeshes("assets/models/testroom.obj");
		model.camera = cam3D;

		model.forEachMesh(function(name:String, mesh:FlxMesh)
		{
			switch (name)
			{
				case "Floor" | "Top":
					mesh.material.setTexture("assets/images/floor.jpg");

				default:
					mesh.material.setTexture("assets/images/wall.png");
			}
		});

		add(model);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// haxeModel.angleY += elapsed * 60;
		// haxeModel.angleX += elapsed * 30;
		// haxeModel.angleZ += elapsed * 15;

		var transform = cam3D.transform;

		if (FlxG.keys.pressed.LEFT)
		{
			transform.angleY -= elapsed * 80;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			transform.angleY += elapsed * 80;
		}

		/*if (FlxG.keys.pressed.UP)
			{
				transform.angleX -= elapsed * 50;
			}
			if (FlxG.keys.pressed.DOWN)
			{
				transform.angleX += elapsed * 50;
		}*/
		/*if (FlxG.keys.pressed.LEFT)
			{
				transform.angleY -= elapsed * 4;
			}
			if (FlxG.keys.pressed.RIGHT)
			{
				transform.angleY += elapsed * 4;
		}*/

		function move(y:Float, x:Float)
		{
			// trace(transform.angleY);
			var ang = cam3D.transform.angleY * (Math.PI / 180);
			// transform.x += y * Math.sin(ang * (Math.PI / 180)) * elapsed * 4 + x * Math.cos(ang * (Math.PI / 180)) * elapsed * 4;
			// transform.z -= y * Math.cos(ang * (Math.PI / 180)) * elapsed * 4 - x * Math.sin(ang * (Math.PI / 180)) * elapsed * 4;

			transform.x += y * Math.sin(-ang) * elapsed * 4 + -x * Math.cos(ang) * elapsed * 4;
			transform.z += y * Math.cos(-ang) * elapsed * 4 + -x * Math.sin(ang) * elapsed * 4;
		}

		if (FlxG.keys.pressed.W)
		{
			move(1, 0);
		}
		if (FlxG.keys.pressed.S)
		{
			move(-1, 0);
		}

		if (FlxG.keys.pressed.A)
		{
			move(0, -1);
		}
		if (FlxG.keys.pressed.D)
		{
			move(0, 1);
		}

		/*if (FlxG.keys.pressed.S)
			{
				transform.x -= Math.sin(transform.angleY * (Math.PI / 180)) * elapsed * 4;
				transform.z += Math.cos(transform.angleY * (Math.PI / 180)) * elapsed * 4;
		}*/
		/*if (FlxG.keys.pressed.DOWN)
			{
				transform.x -= Math.cos(transform.angleY) * elapsed * 4;
		}*/
	}
}
