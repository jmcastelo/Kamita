#version 120

uniform float step1;
uniform float step2;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 t1[9] = vec3[9](texture2D(source, vec2(uv.x - step1, uv.y - step1)).rgb,
                  texture2D(source, vec2(uv.x, uv.y - step1)).rgb,
                  texture2D(source, vec2(uv.x + step1, uv.y - step1)).rgb,
                  texture2D(source, vec2(uv.x - step1, uv.y)).rgb,
                  texture2D(source, uv).rgb,
                  texture2D(source, vec2(uv.x + step1, uv.y)).rgb,
                  texture2D(source, vec2(uv.x - step1, uv.y + step1)).rgb,
                  texture2D(source, vec2(uv.x, uv.y + step1)).rgb,
                  texture2D(source, vec2(uv.x + step1, uv.y + step1)).rgb);
    vec3 color1 = t1[0];
    for (int i = 1; i < 9; i++)
        color1 = max(color1, t1[i]);

    vec3 t2[9] = vec3[9](texture2D(source, vec2(uv.x - step2, uv.y - step2)).rgb,
                  texture2D(source, vec2(uv.x, uv.y - step2)).rgb,
                  texture2D(source, vec2(uv.x + step2, uv.y - step2)).rgb,
                  texture2D(source, vec2(uv.x - step2, uv.y)).rgb,
                  texture2D(source, uv).rgb,
                  texture2D(source, vec2(uv.x + step2, uv.y)).rgb,
                  texture2D(source, vec2(uv.x - step2, uv.y + step2)).rgb,
                  texture2D(source, vec2(uv.x, uv.y + step2)).rgb,
                  texture2D(source, vec2(uv.x + step2, uv.y + step2)).rgb);
    vec3 color2 = t2[0];
    for (int i = 1; i < 9; i++)
        color2 = min(color2, t2[i]);

    gl_FragColor = vec4(mix(t1[4], color1 - color2, alpha), 1.0);
}
