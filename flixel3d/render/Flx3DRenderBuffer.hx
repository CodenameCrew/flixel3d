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
import flixel.group.FlxGroup;
import openfl.geom.Rectangle;
import flixel.FlxBasic;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxSort;
import flixel.group.FlxGroup.FlxTypedGroupIterator;
import flixel.util.FlxArrayUtil;

/**
 * Flx3DRenderBuffer represents the texture which is used as the render target
**/
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(flixel3d.Flx3DMeshData)
@:access(flixel3d.shading.FlxMaterial)
@:access(flixel3d.shading.FlxShader3D)
@:access(flixel3d.Flx3DTexture)
@:access(flixel3d.Flx3DModel)
class Flx3DRenderBuffer extends BitmapData {
	public var camera3D:Flx3DCamera;

	var __renderTarget:RectangleTexture;
	private var _group:FlxGroup;

	private var capabilities:Array<Int>;

	private var depthFunc:Int;

	private var _renderQueue:Array<Flx3DModel>;

	/**
	 * @param   maxSize   Maximum amount of members allowed.
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

		_group = new FlxGroup(maxSize);
		_renderQueue = new Array<Flx3DModel>();

		camera3D = new Flx3DCamera();
	}

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
				var program = mesh.material.applyGL(gl);

				var uCameraPosition = gl.getUniformLocation(program, "uCameraPosition");
				gl.uniform3f(uCameraPosition, camera3D.x, camera3D.y, camera3D.z);

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

	public function render() {
		drawGroup();

		var clearColor = 0xFF00000; // camera.bgColor;
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
		clearGL(gl, clearColor);

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

	/*
		instancing wip

		var uniqueMeshes:Array<Flx3DMesh> = new Array<Flx3DMesh>();
		// var meshes:Array<Flx3DMesh> = new Array<Flx3DMesh>();
		for (mesh in meshes) {
			if (mesh.__instanceCount == 0) {
				uniqueMeshes.push(mesh);
			}
			mesh.__instanceCount++;
		}
		var iPosition:GLUniformLocation = gl.getUniformLocation(program, "iPosition");

		// 32767 instance limit per draw call? or smaller?
		// if instance count exceeds limit (in that case what the actual fuck are you doing), put them in another draw call
		for (mesh in uniqueMeshes) {
			var instanceCount:Int = mesh.__instanceCount;

			while (instanceCount > 0) {
				gl.uniform3fv(iPosition, positions);
				gl.drawElementsInstanced(gl.TRIANGLES, mesh.__elementCount, gl.UNSIGNED_SHORT, 0, Math.min(instanceCount, 32767));
				instanceCount -= 32767;
			}

			mesh.__instanceCount = 0;
	}*/
	/**
	 * `Array` of all the members in this group.
	 */
	public var members(get, null):Array<FlxBasic>;

	public inline function get_members():Array<FlxBasic>
		return _group.members;

	/**
	 * The maximum capacity of this group. Default is `0`, meaning no max capacity, and the group can just grow.
	 */
	public var maxSize(get, set):Int;

	public inline function get_maxSize():Int
		return _group.maxSize;

	public inline function set_maxSize(value:Int):Int
		return _group.maxSize = value;

	/**
	 * The number of entries in the members array. For performance and safety you should check this
	 * variable instead of `members.length` unless you really know what you're doing!
	 */
	public var length(get, null):Int;

	public inline function get_length():Int
		return _group.length;

	/**
	 * A `FlxSignal` that dispatches when a child is added to this group.
	 * @since 4.4.0
	 */
	public var memberAdded(get, never):FlxTypedSignal<FlxBasic->Void>;

	public inline function get_memberAdded():FlxTypedSignal<FlxBasic->Void>
		return _group.memberAdded;

	/**
	 * A `FlxSignal` that dispatches when a child is removed from this group.
	 * @since 4.4.0
	 */
	public var memberRemoved(get, never):FlxTypedSignal<FlxBasic->Void>;

	public inline function get_memberRemoved():FlxTypedSignal<FlxBasic->Void>
		return _group.memberRemoved;

	/**
	 * **WARNING:** A destroyed `FlxBasic` can't be used anymore.
	 * It may even cause crashes if it is still part of a group or state.
	 * You may want to use `kill()` instead if you want to disable the object temporarily only and `revive()` it later.
	 *
	 * This function is usually not called manually (Flixel calls it automatically during state switches for all `add()`ed objects).
	 *
	 * Override this function to `null` out variables manually or call `destroy()` on class members if necessary.
	 * Don't forget to call `super.destroy()`!
	 */
	public function destroy():Void {
		_group.destroy();
	}

	/**
	 * Automatically goes through and calls update on everything you added.
	 */
	public function update(elapsed:Float):Void {
		_group.update(elapsed);
	}

	/**
	 * Automatically goes through and calls render on everything you added.
	 */
	private function drawGroup():Void {
		_group.draw();
	}

	/**
	 * Adds a new `FlxBasic` subclass (`FlxBasic`, `FlxSprite`, `Enemy`, etc) to the group.
	 * `FlxGroup` will try to replace a `null` member of the array first.
	 * Failing that, `FlxGroup` will add it to the end of the member array.
	 * WARNING: If the group has a `maxSize` that has already been met,
	 * the object will NOT be added to the group!
	 *
	 * @param   basic  The `FlxBasic` you want to add to the group.
	 * @return  The same `FlxBasic` object that was passed in.
	 */
	public function add(basic:FlxBasic):FlxBasic {
		if (Std.isOfType(basic, Flx3DModel)) {
			cast(basic, Flx3DModel).views.push(this);
		}
		return _group.add(basic);
	}

	/**
	 * Inserts a new `FlxBasic` subclass (`FlxBasic`, `FlxSprite`, `Enemy`, etc)
	 * into the group at the specified position.
	 * `FlxGroup` will try to replace a `null` member at the specified position of the array first.
	 * Failing that, `FlxGroup` will insert it at the position of the member array.
	 * WARNING: If the group has a `maxSize` that has already been met,
	 * the object will NOT be inserted to the group!
	 *
	 * @param   position  The position in the group where you want to insert the object.
	 * @param   object    The object you want to insert into the group.
	 * @return  The same `FlxBasic` object that was passed in.
	 */
	public function insert(position:Int, object:FlxBasic):FlxBasic {
		return _group.insert(position, object);
	}

	/**
	 * Recycling is designed to help you reuse game objects without always re-allocating or "newing" them.
	 * It behaves differently depending on whether `maxSize` equals `0` or is bigger than `0`.
	 *
	 * `maxSize > 0` / "rotating-recycling" (used by `FlxEmitter`):
	 *   - at capacity:  returns the next object in line, no matter its properties like `alive`, `exists` etc.
	 *   - otherwise:    returns a new object.
	 *
	 * `maxSize == 0` / "grow-style-recycling"
	 *   - tries to find the first object with `exists == false`
	 *   - otherwise: adds a new object to the `members` array
	 *
	 * WARNING: If this function needs to create a new object, and no object class was provided,
	 * it will return `null` instead of a valid object!
	 *
	 * @param   objectClass    The class type you want to recycle (e.g. `FlxSprite`, `EvilRobot`, etc).
	 * @param   objectFactory  Optional factory function to create a new object
	 *                         if there aren't any dead members to recycle.
	 *                         If `null`, `Type.createInstance()` is used,
	 *                         which requires the class to have no constructor parameters.
	 * @param   force          Force the object to be an `ObjectClass` and not a super class of `ObjectClass`.
	 * @param   revive         Whether recycled members should automatically be revived
	 *                         (by calling `revive()` on them).
	 * @return  A reference to the object that was created.
	 */
	public function recycle(?objectClass:Class<FlxBasic>, ?objectFactory:Void->FlxBasic, force = false, revive = true):FlxBasic {
		return _group.recycle(objectClass, objectFactory, force, revive);
	}

	/**
	 * Removes an object from the group.
	 *
	 * @param   basic   The `FlxBasic` you want to remove.
	 * @param   splice  Whether the object should be cut from the array entirely or not.
	 * @return  The removed object.
	 */
	public function remove(basic:FlxBasic, splice = false):FlxBasic {
		if (Std.isOfType(basic, Flx3DModel)) {
			cast(basic, Flx3DModel).views.remove(this);
		}
		return _group.remove(basic, splice);
	}

	/**
	 * Replaces an existing `FlxBasic` with a new one.
	 * Does not do anything and returns `null` if the old object is not part of the group.
	 *
	 * @param   oldObject  The object you want to replace.
	 * @param   newObject  The new object you want to use instead.
	 * @return  The new object.
	 */
	public function replace(oldObject:FlxBasic, newObject:FlxBasic):FlxBasic {
		return _group.replace(oldObject, newObject);
	}

	/**
	 * Call this function to sort the group according to a particular value and order.
	 * For example, to sort game objects for Zelda-style overlaps you might call
	 * `group.sort(FlxSort.byY, FlxSort.ASCENDING)` at the bottom of your `FlxState#update()` override.
	 *
	 * @param   func   The sorting function to use - you can use one of the premade ones in
	 *                     `FlxSort` or write your own using `FlxSort.byValues()` as a "backend".
	 * @param   order  A constant that defines the sort order.
	 *                     Possible values are `FlxSort.ASCENDING` (default) and `FlxSort.DESCENDING`.
	 */
	public inline function sort(func:(Int, FlxBasic, FlxBasic) -> Int, order = FlxSort.ASCENDING):Void {
		return _group.sort(func, order);
	}

	/**
	 * Searches for, and returns the first member that satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function getFirst(func:FlxBasic->Bool):Null<FlxBasic> {
		return _group.getFirst(func);
	}

	/**
	 * Searches for, and returns the last member that satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function getLast(func:FlxBasic->Bool):Null<FlxBasic> {
		return _group.getLast(func);
	}

	/**
	 * Searches for, and returns the index of the first member that satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function getFirstIndex(func:FlxBasic->Bool):Int {
		return _group.getFirstIndex(func);
	}

	/**
	 * Searches for, and returns the index of the last member that satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function getLastIndex(func:FlxBasic->Bool):Int {
		return _group.getLastIndex(func);
	}

	/**
	 * Tests whether any member satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function any(func:FlxBasic->Bool):Bool {
		return _group.any(func);
	}

	/**
	 * Tests whether every member satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function every(func:FlxBasic->Bool):Bool {
		return _group.every(func);
	}

	/**
	 * Call this function to retrieve the first object with `exists == false` in the group.
	 * This is handy for recycling in general, e.g. respawning enemies.
	 *
	 * @param   objectClass  An optional parameter that lets you narrow the
	 *                       results to instances of this particular class.
	 * @param   force        Force the object to be an `ObjectClass` and not a super class of `ObjectClass`.
	 * @return  A `FlxBasic` currently flagged as not existing.
	 */
	public function getFirstAvailable(?objectClass:Class<FlxBasic>, force = false):Null<FlxBasic> {
		return _group.getFirstAvailable(objectClass, force);
	}

	/**
	 * Call this function to retrieve the first index set to `null`.
	 * Returns `-1` if no index stores a `null` object.
	 *
	 * @return  An `Int` indicating the first `null` slot in the group.
	 */
	public function getFirstNull():Int {
		return _group.getFirstNull();
	}

	/**
	 * Call this function to retrieve the first object with `exists == true` in the group.
	 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
	 *
	 * @return  A `FlxBasic` currently flagged as existing.
	 */
	public function getFirstExisting():Null<FlxBasic> {
		return _group.getFirstExisting();
	}

	/**
	 * Call this function to retrieve the first object with `dead == false` in the group.
	 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
	 *
	 * @return  A `FlxBasic` currently flagged as not dead.
	 */
	public function getFirstAlive():Null<FlxBasic> {
		return _group.getFirstAlive();
	}

	/**
	 * Call this function to retrieve the first object with `dead == true` in the group.
	 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
	 *
	 * @return  A `FlxBasic` currently flagged as dead.
	 */
	public function getFirstDead():Null<FlxBasic> {
		return _group.getFirstDead();
	}

	/**
	 * Call this function to find out how many members of the group are not dead.
	 *
	 * @return  The number of `FlxBasic`s flagged as not dead. Returns `-1` if group is empty.
	 */
	public function countLiving():Int {
		return _group.countLiving();
	}

	/**
	 * Call this function to find out how many members of the group are dead.
	 *
	 * @return  The number of `FlxBasic`s flagged as dead. Returns `-1` if group is empty.
	 */
	public function countDead():Int {
		return _group.countDead();
	}

	/**
	 * Returns a member at random from the group.
	 *
	 * @param   startIndex  Optional offset off the front of the array.
	 *                      Default value is `0`, or the beginning of the array.
	 * @param   length      Optional restriction on the number of values you want to randomly select from.
	 * @return  A `FlxBasic` from the `members` list.
	 */
	public function getRandom(startIndex:Int = 0, length:Int = 0) {
		return _group.getRandom(startIndex, length);
	}

	/**
	 * Remove all instances of `FlxBasic` subclasses (`FlxSprite`, `FlxTileblock`, etc) from the list.
	 * WARNING: does not `destroy()` or `kill()` any of these objects!
	 */
	public function clear():Void {
		_group.clear();
	}

	/**
	 * Calls `kill()` on the group's unkilled `members`. Revive them via `reviveMembers()`.
	 * @since 5.4.0
	 */
	public function killMembers():Void {
		_group.killMembers();
	}

	/**
	 * Calls `killMembers()` and then kills the group itself.
	 * Revive this group via `revive()`.
	 */
	public function kill():Void {
		_group.kill();
	}

	/**
	 * Calls `revive()` on the group's killed members and then on the group itself.
	 * @since 5.4.0
	 */
	public function reviveMembers():Void {
		_group.reviveMembers();
	}

	/**
	 * Calls `reviveMembers()` and then revives the group itself.
	 */
	public function revive():Void {
		_group.revive();
	}

	/**
	 * Iterates through every member.
	 */
	public inline function iterator(?filter:FlxBasic->Bool):FlxTypedGroupIterator<FlxBasic> {
		return _group.iterator(filter);
	}

	/**
	 * Iterates through every member and index.
	 */
	public inline function keyValueIterator() {
		return _group.keyValueIterator();
	}

	/**
	 * Applies a function to all members.
	 *
	 * @param   func     A function that modifies one element at a time.
	 * @param   recurse  Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEach(func:FlxBasic->Void, recurse = false) {
		_group.forEach(func, recurse);
	}

	/**
	 * Applies a function to all `alive` members.
	 *
	 * @param   func     A function that modifies one element at a time.
	 * @param   recurse  Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEachAlive(func:FlxBasic->Void, recurse:Bool = false) {
		_group.forEachAlive(func, recurse);
	}

	/**
	 * Applies a function to all dead members.
	 *
	 * @param   func     A function that modifies one element at a time.
	 * @param   recurse  Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEachDead(func:FlxBasic->Void, recurse:Bool = false) {
		_group.forEachDead(func, recurse);
	}

	/**
	 * Applies a function to all existing members.
	 *
	 * @param   func     A function that modifies one element at a time.
	 * @param   recurse  Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEachExists(func:FlxBasic->Void, recurse:Bool = false) {
		_group.forEachExists(func, recurse);
	}

	/**
	 * Applies a function to all members of type `Class<K>`.
	 *
	 * @param   objectClass  A class that objects will be checked against before Function is applied, ex: `FlxSprite`.
	 * @param   func         A function that modifies one element at a time.
	 * @param   recurse      Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEachOfType<K>(objectClass:Class<K>, func:K->Void, recurse:Bool = false) {
		_group.forEachOfType(objectClass, func, recurse);
	}

	public override function dispose():Void {
		_group.destroy();
		super.dispose();
	}
}
