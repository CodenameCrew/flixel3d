package flixel3d;

import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import flixel3d.FlxModel;
import flixel.FlxG;
import flixel.FlxState;
import flixel3d.FlxG3D;
import flixel3d.FlxCamera3D;
import flixel3d.FlxMeshData;
import flixel3d.FlxMesh;
import flixel3d.FlxModel;
import flixel.util.FlxColor;
import flixel.system.FlxAssets;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;

class FlxSplash3D extends FlxState {
	var cam3D:FlxCamera3D;
	var haxeModel:FlxModel;

	public static var nextState:Class<FlxState>;

	public static var muted:Bool = #if html5 true #else false #end;

	function FlxCube():FlxModel {
		var haxeModel = new FlxModel();
		haxeModel.loadMeshes("flixel3d/models/haxe.obj");
		haxeModel.camera = cam3D;
		// trace(haxeModel.meshes);
		add(haxeModel);

		haxeModel.z = 0;
		haxeModel.getMesh("Center").material.color = 0xff00b922;

		haxeModel.getMesh("X+TL").material.color = 0xffffc132;
		haxeModel.getMesh("X-TL").material.color = 0xffffc132;

		haxeModel.getMesh("X+TR").material.color = 0xfff5274e;
		haxeModel.getMesh("X-TR").material.color = 0xfff5274e;
		haxeModel.getMesh("X+BL").material.color = 0xff3641ff;
		haxeModel.getMesh("X-BL").material.color = 0xff3641ff;

		haxeModel.getMesh("X+BR").material.color = 0xff04cdfb;
		haxeModel.getMesh("X-BR").material.color = 0xff04cdfb;

		for (kv in haxeModel.meshes.keyValueIterator()) {
			kv.value.material.color = 0xFF000000;
		}

		return haxeModel;
	}

	var _sprite:Sprite;
	var _gfx:Graphics;
	var _text:TextField;

	var _times:Array<Float>;
	var _colors:Array<FlxColor>;
	var _functions:Array<() -> Void>;
	var _curPart:Int = 0;

	var _cachedBgColor:FlxColor;
	var _cachedTimestep:Bool;
	var _cachedAutoPause:Bool;

	override function create() {
		_cachedBgColor = FlxG.cameras.bgColor;
		FlxG.cameras.bgColor = FlxColor.BLACK;

		// This is required for sound and animation to sync up properly
		_cachedTimestep = FlxG.fixedTimestep;
		FlxG.fixedTimestep = false;

		_cachedAutoPause = FlxG.autoPause;
		FlxG.autoPause = false;

		#if FLX_KEYBOARD
		FlxG.keys.enabled = false;
		#end

		super.create();
		cam3D = new FlxCamera3D();
		FlxG.cameras.add(cam3D, false);

		_times = [0.041, 0.184, 0.334, 0.495, 0.636];
		_colors = [0x00b922, 0xffc132, 0xf5274e, 0x3641ff, 0x04cdfb];
		_functions = [drawGreen, drawYellow, drawRed, drawBlue, drawLightBlue];

		haxeModel = FlxCube();
		haxeModel.z = -5.5;
		haxeModel.angleY = 0;

		for (time in _times) {
			new FlxTimer().start(time, timerCallback);
		}

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		_sprite = new Sprite();
		FlxG.stage.addChild(_sprite);
		_gfx = _sprite.graphics;

		_text = new TextField();
		_text.selectable = false;
		_text.embedFonts = true;
		var dtf = new TextFormat(FlxAssets.FONT_DEFAULT, 16, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		_text.defaultTextFormat = dtf;
		_text.text = "HaxeFlixel";
		FlxG.stage.addChild(_text);

		onResize(stageWidth, stageHeight);

		cam3D.y -= 20;

		#if (flixel >= "5.9.0")
		FlxG.sound.load(FlxAssets.getSoundAddExtension("flixel/sounds/flixel")).play();
		#else
		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/flixel")).play();
		#end
	}

	override public function destroy():Void {
		_sprite = null;
		_gfx = null;
		_text = null;
		_times = null;
		_colors = null;
		_functions = null;
		super.destroy();
	}

	override public function onResize(Width:Int, Height:Int):Void {
		super.onResize(Width, Height);

		_sprite.x = (Width / 2);
		_sprite.y = (Height / 2) - 20 * FlxG.game.scaleY;

		_text.width = Width / FlxG.game.scaleX;
		_text.x = 0;
		_text.y = _sprite.y + 80 * FlxG.game.scaleY;

		_sprite.scaleX = _text.scaleX = FlxG.game.scaleX;
		_sprite.scaleY = _text.scaleY = FlxG.game.scaleY;
	}

	function timerCallback(Timer:FlxTimer):Void {
		_functions[_curPart]();
		_text.textColor = _colors[_curPart];
		_text.text = "HaxeFlixel";
		_curPart++;

		if (_curPart == 5) {
			_text.text = "HaxeFlixel3D";
			// Make the logo a tad bit longer, so our users fully appreciate our hard work :D
			// FlxTween.tween(haxeModel, {angleY: 427.5}, 1.0, {ease: FlxEase.smootherStepOut});
			FlxTween.tween(cam3D.transform, {y: 1.1, angleX: -12.5}, 1.0, {ease: FlxEase.smootherStepOut});
			haxeModel.angularVelocity3D.y = 1900;
			FlxTween.tween(haxeModel.angularVelocity3D, {y: 0}, 1.0, {ease: FlxEase.smootherStepOut});

			FlxTween.tween(cam3D, {alpha: 0}, 2.0, {startDelay: 1.0, ease: FlxEase.quadOut, onComplete: onComplete});
			FlxTween.tween(_text, {alpha: 0}, 2.0, {startDelay: 1.0, ease: FlxEase.quadOut});
		} else if (_curPart == 4) {
			_text.text = "HaxeFlixel3";
		}
	}

	@:access(flixel.FlxGame)
	function onComplete(Tween:FlxTween):Void {
		FlxG.cameras.bgColor = _cachedBgColor;
		FlxG.fixedTimestep = _cachedTimestep;
		FlxG.autoPause = _cachedAutoPause;
		#if FLX_KEYBOARD
		FlxG.keys.enabled = true;
		#end
		FlxG.stage.removeChild(_sprite);
		FlxG.stage.removeChild(_text);
		FlxG.switchState(Type.createInstance(nextState, []));
		FlxG.game._gameJustStarted = true;
	}

	function drawGreen() {
		haxeModel.getMesh("Center").material.color = 0xff00b922;
	}

	function drawYellow() {
		haxeModel.getMesh("X+TL").material.color = 0xffffc132;
		haxeModel.getMesh("X-TL").material.color = 0xffffc132;
	}

	function drawRed() {
		haxeModel.getMesh("X+TR").material.color = 0xfff5274e;
		haxeModel.getMesh("X-TR").material.color = 0xfff5274e;
	}

	function drawBlue() {
		haxeModel.getMesh("X+BL").material.color = 0xff3641ff;
		haxeModel.getMesh("X-BL").material.color = 0xff3641ff;
	}

	function drawLightBlue() {
		haxeModel.getMesh("X+BR").material.color = 0xff04cdfb;
		haxeModel.getMesh("X-BR").material.color = 0xff04cdfb;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		/*haxeModel.angularVelocity3D.y -= elapsed * 2000;
			if (haxeModel.angularVelocity3D.y < 0)
				haxeModel.angularVelocity3D.y = 0; */

		// haxeModel.angularVelocity3D.y = FlxMath.lerp(haxeModel.angularVelocity3D.y, 0, elapsed * 3);
	}
}
