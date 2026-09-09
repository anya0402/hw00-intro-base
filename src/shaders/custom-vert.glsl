#version 300 es

uniform mat4 u_Model;
uniform mat4 u_ModelInvTr;
uniform mat4 u_ViewProj;
uniform float u_Time;

in vec4 vs_Pos;
in vec4 vs_Nor; 
in vec4 vs_Col; 

out vec4 fs_Nor; 
out vec4 fs_LightVec;
out vec4 fs_Col;
out vec4 fs_Pos;

const vec4 lightPos = vec4(5, 5, 3, 1);

// periodic sinc function
float dirichlet(float x, float N) {
    float denom = sin(x * 0.5);
    if (abs(denom) < 0.0001) {
        return N;
    }
    return sin(N * x * 0.5) / denom;
}

void main()
{
    fs_Col = vs_Col;
    float time = u_Time * 0.03;

    mat3 invTranspose = mat3(u_ModelInvTr);
    fs_Nor = vec4(invTranspose * vec3(vs_Nor), 0);

    float x = vs_Pos.x * 3.0 + time;
    float N = 4.0;

    float displacement = dirichlet(x, N) / N;
    vec4 new_pos = vs_Pos + vec4(vs_Nor.xyz * displacement * 0.2, 0.0);

    fs_Pos = new_pos;
    vec4 modelposition = u_Model * new_pos; 

    fs_LightVec = lightPos - modelposition;
    gl_Position = u_ViewProj * modelposition;
}