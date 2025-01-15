package flixel3d;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel3d.FlxSupersampling;
import flixel3d.render.ViewBitmap;
import flixel3d.render.SSAAShader;
import flixel.FlxG;
import openfl.filters.ShaderFilter;

@:access(flixel3d.render.ViewBitmap)
class FlxCamera3D extends FlxCamera {
	public var transform:FlxObject3D;

	private var __supersampling:FlxSupersampling;

	public var supersampling(get, set):FlxSupersampling;
	public var supersamplingFilter:SSAAShader;

	public function get_supersampling():FlxSupersampling {
		return __supersampling;
	}

	public function set_supersampling(value:FlxSupersampling):FlxSupersampling {
		supersamplingFilter.supersampling.value = [value];
		__bitmap3D.resize(this.width * value, this.height * value);
		return __supersampling = value;
	}

	private var __bitmap3D:ViewBitmap;
	private var __renderQueue:Array<FlxModel>;

	public var fov:Float;

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0, fov:Float = 90) {
		super(x, y, width, height, zoom);
		this.fov = fov;
		__renderQueue = new Array<FlxModel>();
		__bitmap3D = new ViewBitmap(this.width, this.height);
		// __bitmap3D.x -= this.width / 2;
		// __bitmap3D.y -= this.height / 2;
		canvas.addChild(__bitmap3D);
		// FlxG.addChildBelowMouse(__bitmap3D);
		// var test = new Bitmap(new BitmapData(1280, 720, true, 0xFF0000FF));
		// flashSprite.addChild(test);
		/*supersamplingFilter = new SSAAShader();
			supersampling = FlxSupersampling.SSAA_4X;
			filters = [new ShaderFilter(supersamplingFilter)]; */
	}

	@:allow(flixel3d.FlxModel)
	private function addToRenderQueue(mesh:FlxModel) {
		__renderQueue.push(mesh);
	}

	@:allow(flixel.system.frontEnds.CameraFrontEnd)
	override function render() {
		super.render();
		__bitmap3D.render(__renderQueue, bgColor);
		__renderQueue = [];
	}
}
