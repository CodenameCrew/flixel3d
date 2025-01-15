package flixel3d.math;

import flixel3d.FlxObject3D;
import lime.utils.Float32Array;

class MatrixUtil
{
    private static final deg2rad = (Math.PI / 180);
    public static macro function __cacheSin()
    {
        var cache:Float32Array = new Float32Array(360);
        for (i in 0...360)
        {
            cache[i] = Math.sin(i * deg2rad);
        }
        return macro $v{cache};
    }
    private static var __cachedSinValues:Float32Array = __cacheSin();
    private static var __matrix:Float32Array = new Float32Array();
    private static function cachedSin(deg:Float)
    {
        return __cachedSinValues[Math.round(deg) % 360];
    }

    private static function cachedCos(deg:Float)
    {
        return cachedSin(90 - deg);
    }

    public static function calculateTransform(obj:FlxObject3D):Float32Array
    {
        // dev note: should i be sentenced to death?

		var rx:Float = obj.angleX;
		var ry:Float = obj.angleY;
		var rz:Float = obj.angleZ;

		// stored in column-major form
		__matrix[0] = cachedCos(rz) * cachedCos(ry);
		__matrix[1] = cachedCos(rz) * cachedSin(ry) * cachedSin(rx) - cachedSin(rz) * cachedCos(rx);
		__matrix[2] = cachedCos(rz) * cachedSin(ry) * cachedCos(rx) + cachedSin(rz) * cachedSin(rx);
		__matrix[3] = obj.x;

		__matrix[4] = cachedSin(rz) * cachedCos(ry);
		__matrix[5] = cachedSin(rz) * cachedSin(ry) * cachedSin(rx) + cachedCos(rz) * cachedCos(rx);
		__matrix[6] = cachedSin(rz) * cachedSin(ry) * cachedCos(rx) - cachedCos(rz) * cachedSin(rx);
		__matrix[7] = obj.y;

		__matrix[8] = -cachedSin(ry);
		__matrix[9] = cachedCos(ry) * cachedSin(rx);
		__matrix[10] = cachedCos(ry) * cachedCos(rx);
		__matrix[11] = obj.z;

		__matrix[12] = 0.;
		__matrix[13] = 0.;
		__matrix[14] = 0.;
		__matrix[15] = 1.;

		return __matrix;
    }
}