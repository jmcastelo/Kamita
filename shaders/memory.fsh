uniform float memory;

uniform sampler2D feedbackSource;
uniform sampler2D memorySource;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 c2 = texture2D(feedbackSource, uv).rgb;
    vec3 c3 = texture2D(memorySource, uv).rgb;
    gl_FragColor = vec4(mix(c2, 0.5 * (c2 + c3), memory), 1.0);
}
