package flixel3d;

import flixel3d.Flx3DCamera;
import flixel.FlxSprite;
import flixel3d.render.Flx3DRenderBuffer;
import flixel.FlxBasic;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.group.FlxGroup.FlxTypedGroupIterator;
import flixel.util.FlxSort;

class Flx3DScene extends FlxSprite {
	private var buffer:Flx3DRenderBuffer;

	public var camera3D(get, set):Flx3DCamera;

	public inline function get_camera3D() {
		return buffer.camera3D;
	}

	public inline function set_camera3D(value:Flx3DCamera) {
		return buffer.camera3D = value;
	}

	public function new(x:Float = 0, y:Float = 0, width:Int = -1, height:Int = -1) {
		super(x, y);
		buffer = new Flx3DRenderBuffer(width, height);
		loadGraphic(buffer);
	}

	public function resize(width:Int, height:Int) {
		buffer.resize(width, height);
	}

	/**
	 * Automatically goes through and calls render on everything you added.
	 */
	override function draw() {
		buffer.render();
		super.draw();
	}

	/**
	 * `Array` of all the members in this group.
	 */
	public var members(get, null):Array<FlxBasic>;

	public inline function get_members():Array<FlxBasic>
		return buffer.members;

	/**
	 * The maximum capacity of this group. Default is `0`, meaning no max capacity, and the group can just grow.
	 */
	public var maxSize(get, set):Int;

	public inline function get_maxSize():Int
		return buffer.maxSize;

	public inline function set_maxSize(value:Int):Int
		return buffer.maxSize = value;

	/**
	 * The number of entries in the members array. For performance and safety you should check this
	 * variable instead of `members.length` unless you really know what you're doing!
	 */
	public var length(get, null):Int;

	public inline function get_length():Int
		return buffer.length;

	/**
	 * A `FlxSignal` that dispatches when a child is added to this group.
	 * @since 4.4.0
	 */
	public var memberAdded(get, never):FlxTypedSignal<FlxBasic->Void>;

	public inline function get_memberAdded():FlxTypedSignal<FlxBasic->Void>
		return buffer.memberAdded;

	/**
	 * A `FlxSignal` that dispatches when a child is removed from this group.
	 * @since 4.4.0
	 */
	public var memberRemoved(get, never):FlxTypedSignal<FlxBasic->Void>;

	public inline function get_memberRemoved():FlxTypedSignal<FlxBasic->Void>
		return buffer.memberRemoved;

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
	public override function destroy():Void {
		buffer.dispose();
		super.destroy();
	}

	/**
	 * Automatically goes through and calls update on everything you added.
	 */
	public override function update(elapsed:Float):Void {
		buffer.update(elapsed);
		super.update(elapsed);
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
		return buffer.add(basic);
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
		return buffer.insert(position, object);
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
		return buffer.recycle(objectClass, objectFactory, force, revive);
	}

	/**
	 * Removes an object from the group.
	 *
	 * @param   basic   The `FlxBasic` you want to remove.
	 * @param   splice  Whether the object should be cut from the array entirely or not.
	 * @return  The removed object.
	 */
	public function remove(basic:FlxBasic, splice = false):FlxBasic {
		return buffer.remove(basic, splice);
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
		return buffer.replace(oldObject, newObject);
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
		return buffer.sort(func, order);
	}

	/**
	 * Searches for, and returns the first member that satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function getFirst(func:FlxBasic->Bool):Null<FlxBasic> {
		return buffer.getFirst(func);
	}

	/**
	 * Searches for, and returns the last member that satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function getLast(func:FlxBasic->Bool):Null<FlxBasic> {
		return buffer.getLast(func);
	}

	/**
	 * Searches for, and returns the index of the first member that satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function getFirstIndex(func:FlxBasic->Bool):Int {
		return buffer.getFirstIndex(func);
	}

	/**
	 * Searches for, and returns the index of the last member that satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function getLastIndex(func:FlxBasic->Bool):Int {
		return buffer.getLastIndex(func);
	}

	/**
	 * Tests whether any member satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function any(func:FlxBasic->Bool):Bool {
		return buffer.any(func);
	}

	/**
	 * Tests whether every member satisfies the function.
	 * @param   func  The function that tests the members
	 * @since 5.4.0
	 */
	public function every(func:FlxBasic->Bool):Bool {
		return buffer.every(func);
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
		return buffer.getFirstAvailable(objectClass, force);
	}

	/**
	 * Call this function to retrieve the first index set to `null`.
	 * Returns `-1` if no index stores a `null` object.
	 *
	 * @return  An `Int` indicating the first `null` slot in the group.
	 */
	public function getFirstNull():Int {
		return buffer.getFirstNull();
	}

	/**
	 * Call this function to retrieve the first object with `exists == true` in the group.
	 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
	 *
	 * @return  A `FlxBasic` currently flagged as existing.
	 */
	public function getFirstExisting():Null<FlxBasic> {
		return buffer.getFirstExisting();
	}

	/**
	 * Call this function to retrieve the first object with `dead == false` in the group.
	 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
	 *
	 * @return  A `FlxBasic` currently flagged as not dead.
	 */
	public function getFirstAlive():Null<FlxBasic> {
		return buffer.getFirstAlive();
	}

	/**
	 * Call this function to retrieve the first object with `dead == true` in the group.
	 * This is handy for checking if everything's wiped out, or choosing a squad leader, etc.
	 *
	 * @return  A `FlxBasic` currently flagged as dead.
	 */
	public function getFirstDead():Null<FlxBasic> {
		return buffer.getFirstDead();
	}

	/**
	 * Call this function to find out how many members of the group are not dead.
	 *
	 * @return  The number of `FlxBasic`s flagged as not dead. Returns `-1` if group is empty.
	 */
	public function countLiving():Int {
		return buffer.countLiving();
	}

	/**
	 * Call this function to find out how many members of the group are dead.
	 *
	 * @return  The number of `FlxBasic`s flagged as dead. Returns `-1` if group is empty.
	 */
	public function countDead():Int {
		return buffer.countDead();
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
		return buffer.getRandom(startIndex, length);
	}

	/**
	 * Remove all instances of `FlxBasic` subclasses (`FlxSprite`, `FlxTileblock`, etc) from the list.
	 * WARNING: does not `destroy()` or `kill()` any of these objects!
	 */
	public function clear():Void {
		buffer.clear();
	}

	/**
	 * Calls `kill()` on the group's unkilled `members`. Revive them via `reviveMembers()`.
	 * @since 5.4.0
	 */
	public function killMembers():Void {
		buffer.killMembers();
	}

	/**
	 * Calls `killMembers()` and then kills the group itself.
	 * Revive this group via `revive()`.
	 */
	public override function kill():Void {
		buffer.kill();
		super.kill();
	}

	/**
	 * Calls `revive()` on the group's killed members and then on the group itself.
	 * @since 5.4.0
	 */
	public function reviveMembers():Void {
		buffer.reviveMembers();
	}

	/**
	 * Calls `reviveMembers()` and then revives the group itself.
	 */
	public override function revive():Void {
		buffer.revive();
		super.revive();
	}

	/**
	 * Iterates through every member.
	 */
	public inline function iterator(?filter:FlxBasic->Bool):FlxTypedGroupIterator<FlxBasic> {
		return buffer.iterator(filter);
	}

	/**
	 * Iterates through every member and index.
	 */
	public inline function keyValueIterator() {
		return buffer.keyValueIterator();
	}

	/**
	 * Applies a function to all members.
	 *
	 * @param   func     A function that modifies one element at a time.
	 * @param   recurse  Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEach(func:FlxBasic->Void, recurse = false) {
		buffer.forEach(func, recurse);
	}

	/**
	 * Applies a function to all `alive` members.
	 *
	 * @param   func     A function that modifies one element at a time.
	 * @param   recurse  Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEachAlive(func:FlxBasic->Void, recurse:Bool = false) {
		buffer.forEachAlive(func, recurse);
	}

	/**
	 * Applies a function to all dead members.
	 *
	 * @param   func     A function that modifies one element at a time.
	 * @param   recurse  Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEachDead(func:FlxBasic->Void, recurse:Bool = false) {
		buffer.forEachDead(func, recurse);
	}

	/**
	 * Applies a function to all existing members.
	 *
	 * @param   func     A function that modifies one element at a time.
	 * @param   recurse  Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEachExists(func:FlxBasic->Void, recurse:Bool = false) {
		buffer.forEachExists(func, recurse);
	}

	/**
	 * Applies a function to all members of type `Class<K>`.
	 *
	 * @param   objectClass  A class that objects will be checked against before Function is applied, ex: `FlxSprite`.
	 * @param   func         A function that modifies one element at a time.
	 * @param   recurse      Whether or not to apply the function to members of subgroups as well.
	 */
	public function forEachOfType<K>(objectClass:Class<K>, func:K->Void, recurse:Bool = false) {
		buffer.forEachOfType(objectClass, func, recurse);
	}
}
