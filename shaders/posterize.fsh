uniform float gamma;
uniform float numColors;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 c = texture2D(source, uv).rgb;
    vec3 x = c;
    x = pow(x, vec3(gamma, gamma, gamma));
    x = x * numColors;
    x = floor(x);
    x = x / numColors;
    x = pow(x, vec3(1.0 / gamma));
    gl_FragColor = vec4(mix(c, x, alpha), 1.0);
}
