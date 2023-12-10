uniform float amount;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 col = texture2D(source, uv).rgb;
    vec3 mixture = mix(col.rgb, col.gbr, amount);
    gl_FragColor = vec4(mix(col, mixture, alpha), 1.0);
}
