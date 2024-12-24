package;
import openfl.display.Shader;
import lime.graphics.PixelFormat;
import lime.graphics.opengl.GL;
import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;
import openfl.display3D.Context3DClearMask;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.graphics.OpenGLRenderContext;
import haxe.io.UInt16Array;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel3d.FlxG3D;
import flixel3d.loaders.ObjLoader;
import haxe.Exception;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.DataPointer;
import lime.utils.Float32Array;
import openfl.Assets;
import openfl.Lib;
import openfl.Vector;
import openfl.display.BitmapData;
import openfl.display.Stage3D;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.Program3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display3D.textures.RectangleTexture;
import openfl.events.Event;
import openfl.utils.ByteArray;
//import sys.io.File;
import openfl.filters.BlurFilter;


/**
 * This is soggy, sloppy and shitty state used to figure out how everything works.
 * If anyone asks, this never existed.
 */
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D._internal.GLProgram)
class TestState extends FlxState
{
	//var loader:ObjLoader;
	var supersampling = 1;
	var indexCount:Int = 0;
	var ibo:GLBuffer;//:IndexBuffer3D;
	var vbo:GLBuffer;//:VertexBuffer3D;

	var vPosition:Int;
	var vColor:Int;
	var vTexCoord:Int;

	var program:GLProgram;
	var _context:Context3D;
	var gl:WebGLRenderContext;

	var texture:RectangleTexture;
	var sp:FlxSprite;

	var ljTexture:GLTexture;

	var ljImage:Image;

	//var webgl

	override public function create()
	{
		super.create();
		_context = Lib.current.stage.context3D;
		// idk if I should be using Context3D.gl or lime.graphics.opengl.GL
		gl = _context.gl;

		//trace("GLSL Version: " + GL.getString(gl.VERSION));

		program = GLProgram.fromSources(gl, Assets.getText("assets/shaders/test.vert"), Assets.getText("assets/shaders/test.frag"));
		
		vPosition = gl.getAttribLocation(program, "vPosition");
		vColor = gl.getAttribLocation(program, "vColor");
		vTexCoord = gl.getAttribLocation(program, "vTexCoord");

		// Vertices
		var load = new ObjLoader();
		load.load("assets/models/haxe.obj");
		var vertexArray = load.vertexArray;
		// there should be a way to pass in a normal array but that is broken and possibly platform-dependent
		var vertexConvert = new Float32Array(vertexArray.length);  
		for (i in 0...vertexArray.length)
		{
			vertexConvert[i] = vertexArray[i];
		}


		vbo = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
		gl.bufferData(gl.ARRAY_BUFFER, vertexConvert, gl.STATIC_DRAW);

		// Indices
		var indexArray = load.elementArray;

		var indexConvert = new lime.utils.UInt16Array(indexArray.length);  
		for (i in 0...indexArray.length)
		{
			indexConvert[i] = indexArray[i];
		}

		indexCount = indexArray.length;

		ibo = gl.createBuffer();
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibo);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indexConvert, gl.STATIC_DRAW);

		texture = _context.createRectangleTexture(1280 * supersampling, 720 * supersampling, BGRA, true);
		var data = BitmapData.fromTexture(texture);

		//@:privateAccess gl.bindTexture(gl.TEXTURE_2D, texture.__textureID);
		//gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		//gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
		//@:privateAccess trace(texture.__textureID.id);
		var ssaa = new SSAAShader();
		ssaa.supersampling.value = [supersampling];
		sp = new FlxSprite().loadGraphic(data);
		sp.setGraphicSize(1280, 720);
		sp.updateHitbox();
		sp.antialiasing = true;
		sp.shader = ssaa;
		add(sp);

		gl.enable(gl.TEXTURE_2D);
		ljImage = Image.fromBitmapData(Assets.getBitmapData("assets/images/itsljcool.png"));
		ljImage.format = PixelFormat.RGBA32;
		//ljImage.data

		//@:privateAccess var textureRaw = texture.__textureID;
		//gl.bindTexture(gl.TEXTURE_2D, textureRaw); 
		//gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, ljImage.width, ljImage.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, ljImage.data);
		/*var testData = File.getBytes("assets/testdata.bin");

		var rats = lime.utils.UInt8Array.fromBytes(testData);
		trace(rats[0], rats[1], rats[2], rats[3]);
		trace(rats[4], rats[5], rats[6], rats[7]);*/

		var view = new lime.utils.UInt8Array(4);
		view[0] = 246;
		view[1] = 136;
		view[2] = 31;
		view[3] = 255;
		
		ljTexture = gl.createTexture();
		gl.bindTexture(gl.TEXTURE_2D, ljTexture);
		//gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, ljImage.width, ljImage.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, ljImage.data);
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, view);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR); 
		//gl.generateMipmap(gl.TEXTURE_2D); 
		trace("LINEAR: " + gl.LINEAR, "NEAREST: " + gl.NEAREST);
	}

	var capabilities:Array<Int> = [
		GL.BLEND, 
		GL.DEPTH_TEST, 
		GL.TEXTURE_2D
	];

	var depthFunc:Int = GL.LESS;

	var time:Float;
	override public function update(elapsed:Float)
	{
		time += elapsed;
		super.update(elapsed);
	}

	override public function draw()
	{
		super.draw();

		_context.setRenderToTexture(texture, true, 4);
		_context.__flushGLFramebuffer();
		_context.__flushGLViewport();

		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, ljTexture);
		

		var preRenderCaps = [for (cap in capabilities) gl.isEnabled(cap)];
		var depthFuncOld = gl.getParameter(gl.DEPTH_FUNC);
		for (cap in capabilities)
			gl.enable(cap);

		gl.depthMask(false);  
		gl.depthFunc(depthFunc);

		// Clear
		gl.colorMask(true, true, true, true);
		gl.clearColor(0, 1, 0, 1);
		gl.depthMask(true);
		gl.clearDepth(1);
		gl.stencilMask(0xFF);
		gl.clearStencil(0);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT | gl.STENCIL_BUFFER_BIT);
		gl.useProgram(program); 

		// Vertex Buffer
		gl.bindBuffer(gl.ARRAY_BUFFER, vbo);

		// Vertex Position
		gl.vertexAttribPointer(vPosition, 3, gl.FLOAT, false, 32, 0);
		gl.enableVertexAttribArray(0);

		// Vertex Color
		gl.vertexAttribPointer(vColor, 3, gl.FLOAT, false, 32, 12);
		gl.enableVertexAttribArray(1);

		// Vertex Texture Position
		gl.vertexAttribPointer(vTexCoord, 2, gl.FLOAT, false, 32, 24);
		gl.enableVertexAttribArray(2);

		// Draw to framebuffer
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibo);
		gl.uniform1f(gl.getUniformLocation(program, "vTime"), time);
		gl.drawElements(gl.TRIANGLES, indexCount, gl.UNSIGNED_SHORT, 0);

		for (i in 0...capabilities.length)
		{
			var cap:Int = capabilities[i];
			var value:Bool = preRenderCaps[i];

			if (!value)
				gl.disable(cap);
		}

		gl.depthFunc(depthFuncOld);
		//gl.bindTexture(gl.TEXTURE_2D, 0);

		_context.setRenderToBackBuffer();
	}
}
