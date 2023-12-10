uniform float scaleX;
uniform float scaleY;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec2 xy = vec2(uv.x * scaleX, uv.y * scaleY);
    if (distance(xy, vec2(0.5 * scaleX, 0.5 * scaleY)) > 0.5)
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else
        gl_FragColor = vec4(texture2D(source, uv).rgb, 1.0);
}
