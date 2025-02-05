package flixel3d;

import haxe.io.Float32Array;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel3d.FlxSupersampling;
import flixel3d.render.ViewBitmap;
import flixel3d.render.SSAAShader;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import lime.utils.Float32Array;
import flixel3d.math.MatrixUtil;
import openfl.display.Sprite;

@:access(flixel3d.render.ViewBitmap) class FlxCamera3D extends FlxCamera {
	private var __supersampling:FlxSupersampling;

	public var transform(default, null):FlxObject3D;
	public var supersampling(get, set):FlxSupersampling;
	public var supersamplingFilter:SSAAShader;

	private var __bitmap3DFilter:Sprite;
	private var __bitmap3D:ViewBitmap;
	private var __renderQueue:Array<FlxModel>;

	public function get_supersampling():FlxSupersampling {
		return __supersampling;
	}

	public function set_supersampling(value:FlxSupersampling):FlxSupersampling {
		// supersamplingFilter.supersampling.value = [value];
		canvas.removeChild(__bitmap3D);
		__bitmap3D.dispose(); // .resize(this.width * value, this.height * value);
		__bitmap3D = new ViewBitmap(this.width * value, this.height * value);
		__bitmap3D.width = this.width;
		__bitmap3D.height = this.height;
		canvas.addChild(__bitmap3D);
		// flashSprite.filters = [new ShaderFilter(supersamplingFilter)];
		return __supersampling = value;
	}

	public var fov:Float;

	private var mx:Float32Array;

	public function resize(width:Int, height:Int) {
		FlxG.resizeGame(width, height);
		setSize(width, height);
		// flashSprite.scaleX = width / this.width;
		// flashSprite.scaleY = height / this.height;
		canvas.removeChild(__bitmap3D);
		__bitmap3D.dispose(); // .resize(this.width * value, this.height * value);
		__bitmap3D = new ViewBitmap(width, height);
		// __bitmap3D.width = this.width;
		// __bitmap3D.height = this.height;
		canvas.addChild(__bitmap3D);
	}

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0, fov:Float = 90) {
		super(x, y, width, height, zoom);
		this.fov = fov;
		__renderQueue = new Array<FlxModel>();
		__bitmap3D = new ViewBitmap(this.width, this.height);
		// __bitmap3D.x -= this.width / 2;
		// __bitmap3D.y -= this.height / 2;
		// __bitmap3DFilter = new Sprite();
		// canvas.addChild(__bitmap3DFilter);
		// __bitmap3DFilter.addChild(__bitmap3D);
		canvas.addChild(__bitmap3D);

		transform = new FlxObject3D();
		// FlxG.addChildBelowMouse(__bitmap3D);
		// var test = new Bitmap(new BitmapData(1280, 720, true, 0xFF0000FF));
		// flashSprite.addChild(test);
		supersamplingFilter = new SSAAShader();
		// supersampling = FlxSupersampling.SSAA_4X;
		// filters = [new ShaderFilter(supersamplingFilter)];
		// supersamplingFilter = new SSAAShader();
		// filters = [new ShaderFilter(supersamplingFilter)];

		// FlxG.signals.gameResized.add(resize);

		mx = new Float32Array(16);
	}

	public override function destroy() {
		FlxG.signals.gameResized.remove(resize);
	}

	public function getTransformMatrix():Float32Array {
		return MatrixUtil.calculateTransform(transform, mx, true);
	}

	@:allow(flixel3d.FlxModel)
	private function addToRenderQueue(model:FlxModel) {
		__renderQueue.push(model);
	}

	@:allow(flixel.system.frontEnds.CameraFrontEnd)
	override function render() {
		super.render();
		__bitmap3D.render(__renderQueue, this);
		__renderQueue = [];
	}
}
