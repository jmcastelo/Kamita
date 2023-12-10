uniform float amount;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 x = texture2D(source, uv).rgb;
    vec3 c = amount + x;
    gl_FragColor = vec4(mix(x, c, alpha), 1.0);
}
