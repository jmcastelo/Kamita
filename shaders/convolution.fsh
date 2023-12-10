uniform float kernel1;
uniform float kernel2;
uniform float kernel3;
uniform float step;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

vec3 convolution(vec3 t1, vec3 t2, vec3 t3, vec3 t4, vec3 t5, vec3 t6, vec3 t7, vec3 t8, vec3 t9)
{
    return kernel3 * t1 + kernel2 * t2 + kernel3 * t3 + kernel2 * t4 + kernel1 * t5 + kernel2 * t6 + kernel3 * t7 + kernel2 * t8 + kernel3 * t9;
}

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 t1 = texture2D(source, vec2(uv.x - step, uv.y - step)).rgb;
    vec3 t2 = texture2D(source, vec2(uv.x, uv.y - step)).rgb;
    vec3 t3 = texture2D(source, vec2(uv.x + step, uv.y - step)).rgb;
    vec3 t4 = texture2D(source, vec2(uv.x - step, uv.y)).rgb;
    vec3 t5 = texture2D(source, uv).rgb;
    vec3 t6 = texture2D(source, vec2(uv.x + step, uv.y)).rgb;
    vec3 t7 = texture2D(source, vec2(uv.x - step, uv.y + step)).rgb;
    vec3 t8 = texture2D(source, vec2(uv.x, uv.y + step)).rgb;
    vec3 t9 = texture2D(source, vec2(uv.x + step, uv.y + step)).rgb;
    vec3 x = convolution(t1, t2, t3, t4, t5, t6, t7, t8, t9);
    float sum = kernel1 + 4.0 * (kernel2 + kernel3);
    if (sum > 0.0) x /= sum;
    vec3 col = clamp(x, 0.0, 1.0);
    gl_FragColor = vec4(mix(t5, col, alpha), 1.0);
}
