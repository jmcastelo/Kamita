uniform bool feedback;
uniform float alpha;

uniform sampler2D source;
uniform sampler2D memorySource;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 c1 = texture2D(source, uv).rgb;
    vec3 c2 = texture2D(memorySource, uv).rgb;
    if (feedback)
        gl_FragColor = vec4(mix(c1, c2, alpha), 1.0);
    else
        gl_FragColor = vec4(c1, 1.0);
}

