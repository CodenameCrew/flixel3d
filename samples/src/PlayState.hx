package;

import flixel3d.Flx3DScene;
import flixel3d.Flx3DModel;

class PlayState extends flixel.FlxState {
	override public function create():Void {
		super.create();

		var view = new Flx3DScene(0, 0, FlxG.width, FlxG.height);
		add(view);

		var model = new Flx3DModel();
		model.loadMeshes("assets/models/testroom.obj");
		view.add(model);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
