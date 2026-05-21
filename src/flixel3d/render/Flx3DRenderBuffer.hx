package flixel3d.render;

import flixel.FlxG;
import haxe.exceptions.NotImplementedException;
import flixel.util.FlxColor;
import openfl.display3D.textures.RectangleTexture;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.WebGLRenderContext;
import flixel3d.internal.Flx3DContext;
import openfl.display.BitmapData;
import lime.graphics.opengl.GL;
import openfl.Lib;
import flixel.group.FlxContainer;
import openfl.geom.Rectangle;
import flixel.FlxBasic;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxSort;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel3d.Flx3DScene.IFlx3DScene;
import flixel3d.internal.Flx3DSceneContainer;

/**
 * Flx3DRenderBuffer is a BitmapData which a 3D scene is rendered onto.
 * This is the underlying framebuffer used by Flx3DScene, so it doesn't usually need to be instantiated manually outside of advanced use cases. 
 */
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(flixel3d.Flx3DGeometry)
@:access(flixel3d.shading.FlxMaterial)
@:access(flixel3d.shading.FlxShader3D)
@:access(flixel3d.Flx3DTexture)
@:access(flixel3d.Flx3DModel)
class Flx3DRenderBuffer extends BitmapData implements IFlx3DScene {
	// just some bullshit needed for the IFlx3DScene interface
	private var _camera3D:Flx3DCamera;
	private var _objects:Flx3DSceneContainer;
	private var _bgColor:FlxColor = 0x00000000;

	/**
	 * The 3D scene's clear colour.
	 */
	public var bgColor(get, set):FlxColor;

	public function get_bgColor()
		return _bgColor;

	public function set_bgColor(value:FlxColor)
		return _bgColor = value;

	/**
	 * The 3D scene's camera.
	 */
	public var camera3D(get, set):Flx3DCamera;

	public function get_camera3D()
		return _camera3D;

	public function set_camera3D(value:Flx3DCamera)
		return _camera3D = value;

	/**
	 * An FlxContainer containing all of the objects in the scene. (Dev note: should this be renamed?)
	 */
	public var objects(get, null):Flx3DSceneContainer;

	public function get_objects()
		return _objects;

	private var __renderTarget:RectangleTexture;
	private var capabilities:Array<Int>;
	private var depthFunc:Int;
	private var _renderQueue:Array<Flx3DModel>;

	/**
	 * @param   width   	Desired width of the framebuffer.
	 * @param   height   	Desired height of the framebuffer.
	 * @param   maxSize  	Maximum amount of members allowed in the objects group.
	 */
	public function new(width:Int, height:Int, maxSize:Int = 0) {
		if (width < 0)
			width = FlxG.width;
		if (height < 0)
			height = FlxG.height;
		super(width, height, true, 0);
		readable = false;
		image = null;
		resize(width, height);

		var gl = Flx3DContext.gl;
		capabilities = [gl.BLEND, gl.DEPTH_TEST, gl.TEXTURE_2D];
		depthFunc = gl.LESS;

		_objects = new Flx3DSceneContainer(this, maxSize);
		_renderQueue = new Array<Flx3DModel>();

		camera3D = new Flx3DCamera();
	}

	/**
	 * Changes the size of the view.
	 */
	public function resize(width:Int, height:Int) {
		if (__texture != null)
			__texture.dispose();

		var ctx = Flx3DContext.context3D;
		__texture = ctx.createRectangleTexture(width, height, BGRA, true);
		__textureContext = __texture.__textureContext;

		this.width = width;
		this.height = height;

		rect = new Rectangle(0, 0, width, height);

		__textureWidth = width;
		__textureHeight = height;
	}

	public function addToRenderQueue(model:Flx3DModel) {
		_renderQueue.push(model);
	}

	private function setRenderToTexture() {
		var ctx = Flx3DContext.context3D;
		ctx.setRenderToTexture(__texture);
	}

	private function flush() {
		var ctx = Flx3DContext.context3D;
		ctx.__flushGLFramebuffer();
		ctx.__flushGLViewport();
	}

	private function clearGL(gl:WebGLRenderContext, color:FlxColor) {
		gl.colorMask(true, true, true, true);
		gl.clearColor(color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat);
		gl.depthMask(true);
		gl.clearDepth(1);
		gl.stencilMask(0xFF);
		gl.clearStencil(0);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT | gl.STENCIL_BUFFER_BIT);
	}

	private function setRenderToBackBuffer() {
		var ctx = Flx3DContext.context3D;
		ctx.setRenderToBackBuffer();
	}

	private function getMeshes() {
		throw new NotImplementedException();
	}

	private function _renderModels(gl:WebGLRenderContext) {
		for (model in _renderQueue) {
			for (mesh in model.meshes) {
				/*var program:GLProgram = mesh.material.__shader.__glProgram;
					gl.useProgram(program);

					// Shader
					mesh.material.applyUniforms(gl);
					if (mesh.material.textures.length != 0) {
						for (i in 0...mesh.material.textures.length) {
							if (i < maxTextureUnits) {
								gl.activeTexture(gl.TEXTURE0 + i);
								gl.bindTexture(gl.TEXTURE_2D, mesh.material.textures[i].__glTexture);
							}
						}
					} else {
						gl.activeTexture(gl.TEXTURE0);
						gl.bindTexture(gl.TEXTURE_2D, Flx3DTexture.defaultTexture.__glTexture);
				}*/
				var program = @:privateAccess mesh.material.applyGL(gl);

				var uCameraPosition = gl.getUniformLocation(program, "uCameraPosition");
				gl.uniform3f(uCameraPosition, camera3D.x, camera3D.y, camera3D.z);

				var uViewSize = gl.getUniformLocation(program, "uViewSize");
				gl.uniform2f(uViewSize, width, height);

				var uViewTransform = gl.getUniformLocation(program, "uViewTransform");
				gl.uniformMatrix4fv(uViewTransform, false, camera3D.getTransformMatrix());
				var uModelTransform = gl.getUniformLocation(program, "uModelTransform");
				gl.uniformMatrix4fv(uModelTransform, false, model.getTransformMatrix());
				// var uPerspectiveTransform = gl.getUniformLocation(program, "uPerspectiveTransform");
				// gl.uniformMatrix4fv(uPerspectiveTransform, false, camera3D.getPerspectiveMatrix());

				// TODO: change when shader implementation is updated
				var vPosition:Int = gl.getAttribLocation(program, "vPosition");
				var vColor:Int = gl.getAttribLocation(program, "vColor");
				var vTexCoord:Int = gl.getAttribLocation(program, "vTexCoord");

				// Vertex Buffer
				gl.bindBuffer(gl.ARRAY_BUFFER, mesh.data.__vertexBuffer);

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
				gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, mesh.data.__elementBuffer);
				gl.drawElements(gl.TRIANGLES, mesh.data.__elementCount, gl.UNSIGNED_SHORT, 0);
			}
		}
	}

	/**
	 * Renders the scene.
	 */
	public function render() {
		_objects.draw();

		// var clearColor = 0xFF00000; // camera.bgColor;
		var gl:WebGLRenderContext = Flx3DContext.gl;
		setRenderToTexture();
		flush();

		var preRenderCaps = [for (cap in capabilities) gl.isEnabled(cap)];
		var depthFuncOld = gl.getParameter(gl.DEPTH_FUNC);
		for (cap in capabilities)
			gl.enable(cap);

		gl.depthMask(false);
		gl.depthFunc(depthFunc);

		// Clear
		clearGL(gl, bgColor);

		_renderModels(gl);
		for (i in 0...capabilities.length) {
			var cap:Int = capabilities[i];
			var value:Bool = preRenderCaps[i];

			if (!value)
				gl.disable(cap);
		}

		gl.depthFunc(depthFuncOld);

		setRenderToBackBuffer();
		FlxArrayUtil.clearArray(_renderQueue);
	}

	public function update(elapsed:Float) {
		_objects.update(elapsed);
	}

	/**
	 * Frees memory that is used to store the Flx3DRenderBuffer object, as well as the 'objects' group.
	 */
	public override function dispose():Void {
		_objects.destroy();
		super.dispose();
	}
}
