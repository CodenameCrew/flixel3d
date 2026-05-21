package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel3d.Flx3DModel;
import flixel3d.Flx3DScene;
import flixel3d.materials.Flx3DShadelessColorMaterial;

class PlayState extends FlxState {
	override public function create() {
		super.create();

		var txtBehind = new FlxText(0, 0, 0, "This text is behind the Flx3DScene", 20);
		txtBehind.color = 0xFFAAFFFF;
		txtBehind.screenCenter();
		txtBehind.y -= 40;
		add(txtBehind);

		var scene = new Flx3DScene(0, 0);
		add(scene);

		var txtFront = new FlxText(0, 0, 0, "This text is in front of the Flx3DScene", 20);
		txtFront.color = 0xFFFFAAFF;
		txtFront.screenCenter();
		txtFront.y += 40;
		add(txtFront);

		var haxeflixel = new Flx3DModel(-2, 0, -10);
		haxeflixel.loadMeshes("flixel3d/models/haxe.obj");

		haxeflixel.angularVelocity3D.y = 30;
		haxeflixel.scale.set(1.5, 1.5, 1.5);

		var green = new Flx3DShadelessColorMaterial(0xFF00B902);
		var red = new Flx3DShadelessColorMaterial(0xFFF52704);
		var yellow = new Flx3DShadelessColorMaterial(0xFFFFC103);
		var darkblue = new Flx3DShadelessColorMaterial(0xFF3641FF);
		var lightblue = new Flx3DShadelessColorMaterial(0xFF04CDFB);

		haxeflixel.applyMaterials([
			"Center" => green,
			"X-TL" => yellow,
			"X-TR" => red,
			"X-BL" => darkblue,
			"X-BR" => lightblue,
			"X+TL" => yellow,
			"X+TR" => red,
			"X+BL" => darkblue,
			"X+BR" => lightblue,
		]);

		scene.objects.add(haxeflixel);

		var suzanne = new Flx3DModel(2, 0, -10).loadMeshes("assets/SuzanneMonkey.obj");
		suzanne.angularVelocity3D.y = 30;

		suzanne.applyMaterials(["Suzanne" => new Flx3DShadelessColorMaterial(0xFF888888)]);

		scene.objects.add(suzanne);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
