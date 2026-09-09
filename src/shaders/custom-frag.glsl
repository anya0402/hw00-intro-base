#version 300 es

precision highp float;

uniform vec4 u_Color;
uniform float u_Time;

in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in vec4 fs_Pos;

out vec4 out_Col;

float random (vec3 st) {
    return fract(sin(dot(st, vec3(12.9898, 78.233, 37.719))) * 43758.5453123);
}

// based on https://www.shadertoy.com/view/4dS3Wd
float noise (vec3 st) {
    vec3 i = floor(st);
    vec3 f = fract(st);

    float c000 = random(i + vec3(0.0, 0.0, 0.0));
    float c100 = random(i + vec3(1.0, 0.0, 0.0));
    float c010 = random(i + vec3(0.0, 1.0, 0.0));
    float c110 = random(i + vec3(1.0, 1.0, 0.0));
    float c001 = random(i + vec3(0.0, 0.0, 1.0));
    float c101 = random(i + vec3(1.0, 0.0, 1.0));
    float c011 = random(i + vec3(0.0, 1.0, 1.0));
    float c111 = random(i + vec3(1.0, 1.0, 1.0));

    vec3 u = f * f * (3.0 - 2.0 * f);

    float x00 = mix(c000, c100, u.x);
    float x10 = mix(c010, c110, u.x);
    float x01 = mix(c001, c101, u.x);
    float x11 = mix(c011, c111, u.x);
    float y0 = mix(x00, x10, u.y);
    float y1 = mix(x01, x11, u.y);

    return mix(y0, y1, u.z);
}

#define OCTAVES 6
float fbm (vec3 st) {
    float value = 0.0;
    float amplitude = 0.5;

    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st = st * 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// based on https://iquilezles.org/articles/warp/
float fbmWarp(vec3 st) {
    float time = u_Time * 0.03;

    // first warp
    vec3 q = vec3(0.0);
    q.x = fbm(st + vec3(0.0, 0.0, 0.0));
    q.y = fbm(st + vec3(5.2, 1.3, 2.7));
    q.z = fbm(st + vec3(2.1, 8.1, 2.4));

    // second warp
    vec3 r = vec3(0.0);
    r.x = fbm(st + 4.0 * q + vec3(1.7, 9.2, 4.4) + 0.15 * time);
    r.y = fbm(st + 4.0 * q + vec3(8.3, 2.8, 5.3) + 0.15 * time);
    r.z = fbm(st + 4.0 * q + vec3(3.4, 5.3, 2.2) + 0.15 * time);

    return fbm(st + 4.0 * r);
}

void main() {
    float fbm_val = fbmWarp(fs_Pos.xyz * 3.0);

    vec3 color1 = vec3(0.0, 1.0, 0.898);
    vec3 color2 = vec3(0.157, 0.831, 0.937);
    vec3 color3 = vec3(0.376, 0.573, 1.0);
    vec3 color4 = vec3(0.522, 0.259, 0.851);
    vec3 color5 = vec3(0.216, 0.086, 0.412);

    vec3 col = color1;
    col = mix(col, color2, smoothstep(0.1, 0.4, fbm_val));
    col = mix(col, color3,   smoothstep(0.35, 0.55, fbm_val));
    col = mix(col, color4,   smoothstep(0.5, 0.7, fbm_val));
    col = mix(col, color5,   smoothstep(0.75, 0.95, fbm_val));

    vec3 remappedColor = mix(vec3(0.627), vec3(1.0), u_Color.rgb);
    vec4 diffuseColor = vec4(remappedColor.rbg, u_Color.a);
    diffuseColor.rgb *= col;

    // lambert
    float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
    diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);
    diffuseTerm = diffuseTerm * 0.4;
    float ambientTerm = 0.7;
    float lightIntensity = diffuseTerm + ambientTerm;

    out_Col = vec4(diffuseColor.rgb * lightIntensity, diffuseColor.a);
}