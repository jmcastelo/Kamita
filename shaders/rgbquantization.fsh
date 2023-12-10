uniform int redLevels;
uniform int greenLevels;
uniform int blueLevels;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 c = texture2D(source, uv).rgb;
    vec3 levels = vec3(redLevels, greenLevels, blueLevels);
    vec3 color = floor(levels * c - 0.5) / (levels - 1.0);
    gl_FragColor = vec4(mix(c, color, alpha), 1.0);
}
