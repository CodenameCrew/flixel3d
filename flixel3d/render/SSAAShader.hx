package flixel3d.render;

import flixel.system.FlxAssets.FlxShader;

class SSAAShader extends FlxShader {
	@:glFragmentSource("
    #pragma header

    uniform int supersampling;
    
    vec2 getPixelOffset(vec2 position, vec2 offset)
    {
        return position + (offset / openfl_TextureSize.xy);
    }

    void main(void) {
    
        vec4 sum = vec4(0.0);
        float supersamplingsq = float(supersampling * supersampling);
        for (int x = 0; x < supersampling; x++)
        {
            for (int y = 0; y < supersampling; y++)
            {
                sum += texture2D(bitmap, getPixelOffset(openfl_TextureCoordv, vec2(x, y))) / supersamplingsq;
            }
        }
        gl_FragColor = sum;

    }")
	/*
		int halfsupersampling = supersampling / 2;
		for (int x = -halfsupersampling; x < halfsupersampling; x++)
		{
			for (int y = 0; y < halfsupersampling; y++)
	 */
	public function new() {
		super();
	}
}
