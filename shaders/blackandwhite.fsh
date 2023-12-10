uniform float threshold;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 col = texture2D(source, uv).rgb;
    float y = (col.r + col.g + col.b) / 3.0;
    y = y < threshold ? 0.0 : 1.0;
    vec3 c = vec3(y, y, y);
    gl_FragColor = vec4(mix(col, c, alpha), 1.0);
}
