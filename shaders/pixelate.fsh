uniform float granularity;
uniform float targetWidth;
uniform float targetHeight;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec2 tc = qt_TexCoord0;
    if (granularity > 0.0) {
        float dx = granularity / targetWidth;
        float dy = granularity / targetHeight;
        tc = vec2(dx*(floor(uv.x/dx) + 0.5),
                  dy*(floor(uv.y/dy) + 0.5));
    }
    vec3 c = texture2D(source, uv).rgb;
    vec3 x = texture2D(source, tc).rgb;
    gl_FragColor = vec4(mix(c, x, alpha), 1.0);
}
