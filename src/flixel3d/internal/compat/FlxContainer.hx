package flixel3d.internal.compat;

#if (flixel < "5.7.0")
import flixel.FlxBasic;
import flixel.group.FlxGroup;

@:dox(hide) typedef FlxContainer = FlxTypedContainer<FlxBasic>;

/**
 * FlxTypedContainer compatibility versions prior to 5.7.0
 */
@:dox(hide) class FlxTypedContainer<T:FlxBasic> extends FlxTypedGroup<T> implements IContainerCompat {
	public var container:Null<FlxContainer>;
	/**
	 * @param   maxSize  Maximum amount of members allowed.
	 */
	public function new(maxSize = 0) {
		super(maxSize);
		memberAdded.add(_onMemberAdd);
		memberRemoved.add(_onMemberAdd);
	}

	function _onMemberAdd(member:T) {
		if (!Std.isOfType(member, IContainerCompat)) return;
		
		var cMember = (cast member : IContainerCompat); 
		// remove from previous container
		if (cMember.container != null)
			cMember.container.remove(member);

		cMember.container = (cast this : FlxContainer);
	}

	function _onMemberRemove(member:T) {
		if (!Std.isOfType(member, IContainerCompat)) return;

		var cMember = (cast member : IContainerCompat); 
		cMember.container = null;
	}
}

interface IContainerCompat {
	public var container:Null<FlxContainer>;
}
#end
