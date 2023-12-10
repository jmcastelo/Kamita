#version 120

uniform float step;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 t[9] = vec3[9](texture2D(source, vec2(uv.x - step, uv.y - step)).rgb,
                  texture2D(source, vec2(uv.x, uv.y - step)).rgb,
                  texture2D(source, vec2(uv.x + step, uv.y - step)).rgb,
                  texture2D(source, vec2(uv.x - step, uv.y)).rgb,
                  texture2D(source, uv).rgb,
                  texture2D(source, vec2(uv.x + step, uv.y)).rgb,
                  texture2D(source, vec2(uv.x - step, uv.y + step)).rgb,
                  texture2D(source, vec2(uv.x, uv.y + step)).rgb,
                  texture2D(source, vec2(uv.x + step, uv.y + step)).rgb);
    vec3 color = t[0];
    for (int i = 1; i < 9; i++)
        color = max(color, t[i]);
    gl_FragColor = vec4(mix(t[4], color, alpha), 1.0);
}
