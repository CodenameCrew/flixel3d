package flixel3d.shading;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;

@:access(openfl.display3D.Context3D)
@:allow(flixel3d.render.ViewBitmap)
class FlxShader3D {
	var __glProgram:GLProgram;
	var uniforms:Map<String, Dynamic>;

	public static final DEFAULT_FRAGMENT = "
		#ifdef GL_ES
		precision highp float;
		#endif

		varying vec2 fTexCoord;
		varying vec3 fColor;

		uniform sampler2D bitmap;
		uniform vec4 uModelColor;
		uniform vec4 uColor;

		float near = 07.;
		float far = 8.;

		/*float LinearizeDepth(float depth) 
		{
			float z = depth * 2.0 - 1.0; // back to NDC 
			return (2.0 * near * far) / (far + near - z * (far - near));	
		}*/

		uniform float iTime;
		uniform float light;
		void main()
		{
			//float depth = LinearizeDepth(gl_FragCoord.z) / far; // divide by far for demonstration
			//float depth = (gl_FragCoord.z + 5.0) * 0.01; //0.01;
			//FragColor = vec4(vec3(depth), 1.0);
			//fragColor = vec4(texture(bitmap, fTexCoord).rgb * depth, 1.0); //vec4(fColor * gl_FragCoord.z, 1.0); //0.5 * (1. + sin(iTime))
			gl_FragColor = texture2D(bitmap, fTexCoord) * uColor * uModelColor * vec4(fColor, 1.);
		}

	";

	public static final DEFAULT_VERTEX = "
		#ifdef GL_ES
		precision highp float;
		#endif

		#define PI 3.14159265

		attribute vec3 vPosition;
		attribute vec3 vColor;
		//attribute vec3 vNormal;
		attribute vec2 vTexCoord;

		uniform vec3 uCameraPosition;
		uniform mat4 uViewTransform;
		uniform mat4 uModelTransform;

		varying vec3 fColor;
		varying vec2 fTexCoord;

		uniform float uTime;

		float far = 100.;
		float near = 0.1;
		float aspect=16./9.;
		float fov = 70.;

		void main()
		{
			mat4 projection;  
			projection[0] = vec4(1./(aspect*tan(fov/2.)),  0.,              0.,                          0.);
			projection[1] = vec4(0.,                    1./tan(fov/2.),   0.,                          0.);
			projection[2] = vec4(0.,                    0.,              -((far+near)/(far-near)),   -((2.*far*near)/(far-near)));
			projection[3] = vec4(0.,                    0.,              -1.,                         0.);

			mat4 model = uModelTransform; 

			mat4 view = uViewTransform; 

			float lightness = 0.5 +  (vPosition.z) / 2.;
			fColor = vColor;// * lightness;
			fTexCoord = vTexCoord;
			vec4 pos = vec4(vPosition * vec3(1, -1, 1) + uCameraPosition, 1.) * model * view * projection;
			
			gl_Position = pos;
		}
	";

	private static var _defaultShader:FlxShader3D;
	public static var defaultShader(get, null):FlxShader3D;

	public static function get_defaultShader() {
		if (_defaultShader != null)
			return _defaultShader;
		_defaultShader = new FlxShader3D(DEFAULT_FRAGMENT, DEFAULT_VERTEX);
		return _defaultShader;
	}

	public function new(fragmentSource:String, vertexSource:String) {
		uniforms = new Map<String, Dynamic>();
		__glProgram = GLProgram.fromSources(FlxG3D.context3D.gl, vertexSource, fragmentSource);
	}
}
