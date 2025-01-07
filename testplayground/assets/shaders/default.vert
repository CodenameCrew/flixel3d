//#version 330 es //#version 120
precision highp float;

#define PI 3.14159265

attribute vec3 vPosition;
attribute vec3 vColor;
//attribute vec3 vNormal;
attribute vec2 vTexCoord;
//attribute mat4 vTransform;

uniform mat4 uTransform;

varying vec3 fColor;
varying vec2 fTexCoord;

//uniform vec3 modelPosition = vec3(0., 0., -5.);
//uniform vec3 modelRotation = vec3(0., vTime, 0.);
uniform vec3 positions[128];
uniform vec3 rotations[128];

//uniform float vTime;

float far = 100.;
float near = 0.1;
float aspect=16./9.;
float fov = 70.;


/*vec4 quaternion;

vec3 rotate_vertex_position(vec3 v, vec4 q)
{ 
  return v + 2.0 * cross(q.xyz, cross(q.xyz, v) + q.w * v);
}*/

// https://gamedev.stackexchange.com/questions/120338/what-does-a-projection-projection-matrix-look-like-in-opengl

mat4 transformMatrix(vec3 position, vec3 rotation)
{
    float a = rotation.z;
    float b = rotation.y;
    float y = rotation.x;

    mat4 matrix;
    matrix[0] = vec4(cos(a)*cos(b),    cos(a)*sin(b)*sin(y)-sin(a)*cos(y),   cos(a)*sin(b)*cos(y)+sin(a)*sin(y),   position.x);
    matrix[1] = vec4(sin(a)*cos(b),    sin(a)*sin(b)*sin(y)+cos(a)*cos(y),   sin(a)*sin(b)*cos(y)-cos(a)*sin(y),   position.y);
    matrix[2] = vec4(-sin(b),          cos(b)*sin(y),                        cos(b)*cos(y),                        position.z);
    matrix[3] = vec4(0.,               0.,                                   0.,                                   1.);

    return matrix;
}

void main()
{
    //vec3 modelPosition = vec3(0., 0., -5.);
    //vec3 modelRotation = vec3(0., vTime, 0.);

    mat4 projection;  
    projection[0] = vec4(1./(aspect*tan(fov/2.)),  0.,              0.,                          0.);
    projection[1] = vec4(0.,                    1./tan(fov/2.),   0.,                          0.);
    projection[2] = vec4(0.,                    0.,              -((far+near)/(far-near)),   -((2.*far*near)/(far-near)));
    projection[3] = vec4(0.,                    0.,              -1.,                         0.);

    mat4 model = uTransform; //transformMatrix(modelPosition, modelRotation);
    
    mat4 view = transformMatrix(vec3(0., 0., 0.), vec3(0., 0., 0.));

    fColor = vColor;
    fTexCoord = vTexCoord;
    gl_Position = vec4(vPosition, 1.) * model * view * projection;
}
