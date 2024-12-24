#version 120

//out vec4 fragColor;

varying vec2 fTexCoord;
varying vec3 fColor;

uniform sampler2D bitmap;

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
    gl_FragColor = texture2D(bitmap, fTexCoord);
}
