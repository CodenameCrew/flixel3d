package flixel3d;

abstract FlxSupersampling(Int) from Int from UInt to Int to UInt {
	public static inline var SSAA_2X:FlxSupersampling = 2;
	public static inline var SSAA_4X:FlxSupersampling = 4;
	public static inline var SSAA_8X:FlxSupersampling = 8;
	public static inline var SSAA_16X:FlxSupersampling = 16;
}
