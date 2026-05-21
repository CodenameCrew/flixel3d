package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel3d.Flx3DModel;
import flixel3d.Flx3DScene;

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

		var suzanne = new Flx3DModel(0, 0, -10).loadMeshes("assets/SuzanneMonkey.obj");
		scene.objects.add(suzanne);
		suzanne.angularVelocity3D.y = 30;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
