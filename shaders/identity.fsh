uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 color = texture2D(source, uv).rgb;
    gl_FragColor = vec4(color, 1.0);
}
