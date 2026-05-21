package flixel3d.internal;

import flixel.FlxBasic;
import flixel3d.render.Flx3DRenderBuffer;
#if (flixel > "5.7.0")
import flixel.group.FlxContainer.FlxTypedContainer;
#else
import flixel3d.internal.compat.FlxContainer.FlxTypedContainer;
#end

@:dox(hide) class Flx3DTypedSceneContainer<T:FlxBasic> extends FlxTypedContainer<T> {
	private var parentScene:Flx3DRenderBuffer;

	public function new(parentScene:Flx3DRenderBuffer, maxSize) {
		super(maxSize);
		this.parentScene = parentScene;
	}
}

@:dox(hide) typedef Flx3DSceneContainer = Flx3DTypedSceneContainer<FlxBasic>;
